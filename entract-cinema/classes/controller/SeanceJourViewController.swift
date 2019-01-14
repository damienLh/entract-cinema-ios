//
//  SeanceJourViewController.swift
//  L'entract
//
//  Created by dlheuillier on 27/06/2018
//  Copyright © 2018 Entract. All rights reserved.
//

import UIKit
import EventKit

class SeanceJourViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var datePicker: UIPickerView!
    var pickerData: [String] = [String]()
    var pickerTitle: [String] = [String]()
    
    
    @IBOutlet weak var seancesTableView: UITableView!
    
    var mapFilms: [String: [Film]]!
    var jour: String!
    var detailSeance: SeanceTapGesture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        
        let completeDateFormatter = DateFormatter()
        completeDateFormatter.dateFormat =  "EEEE dd LLLL"
        completeDateFormatter.locale = Locale(identifier: "fr")

        let dateMin = dateFormatter.date(from: UserDefaults.standard.string(forKey: Constants.dateMin)!)
        let dateMax = dateFormatter.date(from: UserDefaults.standard.string(forKey: Constants.dateMax)!)
        
        if var minDate = dateMin, let maxDate = dateMax {
            self.jour = dateFormatter.string(from: minDate)
            while minDate.compare(maxDate) != .orderedDescending {
                pickerData.append(dateFormatter.string(from: minDate))
                pickerTitle.append(completeDateFormatter.string(from: minDate))
                minDate = Calendar.current.date(byAdding: .day, value: 1, to: minDate)!
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(Tools.shared.offlineModeAlert(notification:)), name: .flagsChanged, object: self)

        self.seancesTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.backgroundColor = Tools.shared.manageWindowTheme()
        self.seancesTableView.backgroundColor = Tools.shared.manageWindowTheme()
        loadFilms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        loadFilms()
        self.seancesTableView.reloadData()
        self.view.backgroundColor = Tools.shared.manageWindowTheme()
        self.seancesTableView.backgroundColor = Tools.shared.manageWindowTheme()
        self.datePicker.reloadAllComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managePopup()
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.seancesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerTitle[row], attributes: [NSAttributedString.Key.foregroundColor : Tools.shared.manageTheme()])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dateSelectionnee = pickerData[row]
        self.jour = dateSelectionnee
        loadFilms()
        self.seancesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func managePopup() {
        if UserDefaults.standard.bool(forKey: Constants.visualiserTuto) {
            if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "tutorialViewController") {
                presentedViewController.providesPresentationContextTransitionStyle = true
                presentedViewController.definesPresentationContext = true
                presentedViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
                presentedViewController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
                self.present(presentedViewController, animated: true, completion: nil)
            }
        } else {
            if UserDefaults.standard.bool(forKey: Constants.autoriserAnnonce), !UserDefaults.standard.bool(forKey: Constants.annonceAfficheeSession) {
                let annonce = JSONUnparser.getAfficheEvenements()
                if !annonce.isEmpty {
                    if let annonceVC:AfficheEvenementViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "afficheEvenementViewController") as? AfficheEvenementViewController {
                        Statistiques.statEvenement()
                        annonceVC.annonce = annonce
                        self.present(annonceVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listeFilms = mapFilms[self.jour] {
            return listeFilms.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mapFilms[self.jour] != nil {
            return 320.0
        }
        return 53.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if let listeFilms = mapFilms[self.jour] {
            let seanceCell = tableView.dequeueReusableCell(withIdentifier: "seanceCell", for: indexPath) as! SeanceTableViewCell
            seanceCell.backgroundColor = Tools.shared.manageWindowTheme()
            let film = listeFilms[indexPath.row]
            
            if NetworkUtils.isUserConnectedToWifi() || !UserDefaults.standard.bool(forKey: Constants.bandeAnnonceUniquementWIFI) {
                if let url = URL(string: film.affiche) {
                    seanceCell.afficheImageView.contentMode = .scaleAspectFit
                    Tools.shared.downloadImage(url: url, imageView: seanceCell.afficheImageView, activity: seanceCell.activityLoad)
                }
            } else {
                seanceCell.afficheImageView.image = UIImage(named: "seance_non_dispo")
            }
            
            let titreFilm = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : entractColor]
            let infoFilm = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : Tools.shared.manageTheme()]
            
            let titreContent = NSMutableAttributedString()
            titreContent.append(NSMutableAttributedString(string:"\(film.titre)", attributes:titreFilm))
            
            seanceCell.titreLabel.attributedText = titreContent
            
            let content = NSMutableAttributedString()
            content.append(NSMutableAttributedString(string:"\(film.horaire) - ", attributes:infoFilm))
            content.append(NSMutableAttributedString(string:"\(film.duree) ", attributes:infoFilm))

            if film.troisD {
                content.append(Tools.shared.attributedTextWithImage(imageName: Constants.threeD))
            }
            if film.vo {
                content.append(Tools.shared.attributedTextWithImage(imageName: Constants.vost))
            }

            if film.avertissement {
                content.append(Tools.shared.attributedTextWithImage(imageName: Constants.avertissement))
            }
            
            if film.moinsDouze {
                content.append(Tools.shared.attributedTextWithImage(imageName: Constants.moinsDouze))
            }
            
            seanceCell.infosFilm.attributedText = content

            let seanceGesture = SeanceTapGesture(target: self, action: #selector(tappedMovie(tapGestureRecognizer:)))
            seanceGesture.detail = film
            seanceCell.afficheImageView.isUserInteractionEnabled = true
            seanceCell.afficheImageView.addGestureRecognizer(seanceGesture)
            
            let calendarGesture = SeanceTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            calendarGesture.detail = film
            calendarGesture.sender = seanceCell.btnCalendrier
            
            if !isAlertFilmInCalendar(detail: film) {
                seanceCell.btnCalendrier.isUserInteractionEnabled = true
                seanceCell.btnCalendrier.setTitle("alerte_film_ko".localized(), for: UIControl.State.normal)
                seanceCell.btnCalendrier.setTitleColor(blueColor, for: UIControl.State.normal)
                seanceCell.btnCalendrier.addGestureRecognizer(calendarGesture)
                seanceCell.btnCalendrier.setImage(UIImage(named: "calendar"), for: .normal)
            } else {
                seanceCell.btnCalendrier.isUserInteractionEnabled = true
                seanceCell.btnCalendrier.setTitle("alerte_film_ok".localized(), for: UIControl.State.normal)
                seanceCell.btnCalendrier.setTitleColor(entractColor, for: UIControl.State.normal)
                seanceCell.btnCalendrier.addGestureRecognizer(calendarGesture)
                seanceCell.btnCalendrier.setImage(UIImage(named: "calendar_active"), for: .normal)
            }
            
            cell = seanceCell
        } else {
            let noSeanceCell = tableView.dequeueReusableCell(withIdentifier: "noSeanceCell", for: indexPath) as! NoSeanceTableViewCell
            noSeanceCell.lblNoSeance.text = "pas_de_film".localized()
            noSeanceCell.lblNoSeance.textColor = Tools.shared.manageTheme()
            noSeanceCell.backgroundColor = Tools.shared.manageWindowTheme()
            cell = noSeanceCell
        }

        return cell
    }
    
    func loadFilms() {
        self.mapFilms = [:]
            let films : [Film] = JSONUnparser.getFilms(dateJour: self.jour)
            for film in films {
                if let _ = self.mapFilms[self.jour] {
                    self.mapFilms[self.jour]?.append(film)
                } else {
                    var array = [Film]()
                    array.append(film)
                    self.mapFilms[self.jour] = array
                }
            }
            
            for date in self.mapFilms.keys {
                let films = self.mapFilms[date]?.sorted(by: { $0.horaire < $1.horaire })
                self.mapFilms[date] = films
            }
    }
    
    func addEventToCalendar(film: Film, description: String?, startDate: Date, endDate: Date,sender: UIButton, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = film.titre
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                let structuredLocation = EKStructuredLocation(title:"cinema".localized())
                let location = CLLocation(latitude: 43.7700499, longitude: 1.2948405)
                structuredLocation.geoLocation = location
                structuredLocation.radius = 1000
                event.structuredLocation = structuredLocation
                
                let valeurRappel = UserDefaults.standard.integer(forKey: Constants.tempsAlerte)
                print("valeur alarme \(valeurRappel)")
                
                let alarm:EKAlarm = EKAlarm(relativeOffset: TimeInterval(-60 * valeurRappel))
                event.alarms = [alarm]
                
                if !self.isAlertFilmInCalendar(detail: film) {
                    do {
                        try eventStore.save(event, span: .thisEvent)
                        Statistiques.statCalendrier(idSeance: film.id_seance, isRemove: false)
                    } catch let e as NSError {
                        completion?(false, e)
                        return
                    }
                    completion?(true, nil)
                    
                    let alert = UIAlertController(title: "cinema".localized(), message: "filmCalendrier".localized(), preferredStyle: UIAlertController.Style.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        sender.setTitle("alerte_film_ok".localized(), for: UIControl.State.normal)
                        sender.setTitleColor(entractColor, for: UIControl.State.normal)
                        sender.setImage(UIImage(named: "calendar_active"), for: .normal)
                    }
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "suppressionAlerte".localized(), message: "suppressionAlerteMessage".localized(), preferredStyle: .alert)
                    
                    let actionOK = UIAlertAction(title: "continuer".localized(), style: .default) { (action:UIAlertAction) in
                        
                        do {
                            let myEvent = self.getEventInCalendar(detail: film);
                            let eventToRemove = eventStore.event(withIdentifier: myEvent.eventIdentifier);
                            try eventStore.remove(eventToRemove!, span: .thisEvent, commit: true)
                            Statistiques.statCalendrier(idSeance: film.id_seance, isRemove: true)
                        } catch let e as NSError {
                            completion?(false, e)
                            return
                        }
                        completion?(true, nil)
                        sender.setTitle("alerte_film_ko".localized(), for: UIControl.State.normal)
                        sender.setTitleColor(blueColor, for: UIControl.State.normal)
                        sender.setImage(UIImage(named: "calendar"), for: .normal)
                    }
                    
                    let actionCancel = UIAlertAction(title: "annuler".localized(), style: .cancel) { (action:UIAlertAction) in
                    }
                    
                    alertController.addAction(actionCancel)
                    alertController.addAction(actionOK)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                }
            } else {
                completion?(false, error as NSError?)
                
                let alert = UIAlertController(title: "cinema".localized(), message: "calendarNotGranted".localized(), preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

    @objc func imageTapped(tapGestureRecognizer: SeanceTapGesture)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: self.jour!)!
        
        let calendar = Calendar.current
        let yearToday = calendar.component(.year, from: myDate)
        let monthToday = calendar.component(.month, from: myDate)
        let dayToday = calendar.component(.day, from: myDate)
        
        let heure = tapGestureRecognizer.detail.horaire
        let duree = tapGestureRecognizer.detail.duree
        
        var temps = duree.components(separatedBy: "h")
        let hourFilm:Int = Int(temps[0])! * 60
        let minFilm:Int = Int(temps[1])!
        let totalTime = (hourFilm + minFilm) * 60
        
        var startFormat: String = String(format:"%d/%d/%d %@", yearToday, monthToday, dayToday, heure)
        startFormat = startFormat.replacingOccurrences(of: "h", with: ":", options: .literal, range: nil)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let debut = formatter.date(from: startFormat)
        let fin = debut?.addingTimeInterval(TimeInterval(totalTime))
        
        addEventToCalendar(film: tapGestureRecognizer.detail, description: "cinema".localized(), startDate: debut!, endDate: fin!, sender: tapGestureRecognizer.sender)
    }
    
    func isAlertFilmInCalendar(detail: Film) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: self.jour!)!
        
        let eventStore = EKEventStore()
        let calendar = Calendar.current
        let yearToday = calendar.component(.year, from: myDate)
        let monthToday = calendar.component(.month, from: myDate)
        let dayToday = calendar.component(.day, from: myDate)
        
        let heure = detail.horaire
        let film = detail.titre
        let duree = detail.duree
        
        var temps = duree.components(separatedBy: "h")
        let hourFilm:Int = Int(temps[0])! * 60
        let minFilm:Int = Int(temps[1])!
        let totalTime = (hourFilm + minFilm) * 60
        
        var startFormat: String = String(format:"%d/%d/%d %@", yearToday, monthToday, dayToday, heure)
        startFormat = startFormat.replacingOccurrences(of: "h", with: ":", options: .literal, range: nil)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let debut = formatter.date(from: startFormat)
        let fin = debut?.addingTimeInterval(TimeInterval(totalTime))
        
        let predicate = eventStore.predicateForEvents(withStart: debut!, end: fin!, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        var alreadyExists = false
        for singleEvent in existingEvents {
            if singleEvent.title == film && singleEvent.startDate == debut && singleEvent.endDate == fin {
                alreadyExists = true
                break
            }
        }
        
        return alreadyExists
    }
    
    func getEventInCalendar(detail: Film) -> EKEvent {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: self.jour!)!
        
        let eventStore = EKEventStore()
        let calendar = Calendar.current
        let yearToday = calendar.component(.year, from: myDate)
        let monthToday = calendar.component(.month, from: myDate)
        let dayToday = calendar.component(.day, from: myDate)
        
        let heure = detail.horaire
        let film = detail.titre
        let duree = detail.duree
        
        var temps = duree.components(separatedBy: "h")
        let hourFilm:Int = Int(temps[0])! * 60
        let minFilm:Int = Int(temps[1])!
        let totalTime = (hourFilm + minFilm) * 60
        
        var startFormat: String = String(format:"%d/%d/%d %@", yearToday, monthToday, dayToday, heure)
        startFormat = startFormat.replacingOccurrences(of: "h", with: ":", options: .literal, range: nil)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let debut = formatter.date(from: startFormat)
        let fin = debut?.addingTimeInterval(TimeInterval(totalTime))
        
        let predicate = eventStore.predicateForEvents(withStart: debut!, end: fin!, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        for singleEvent in existingEvents {
            if singleEvent.title == film && singleEvent.startDate == debut && singleEvent.endDate == fin {
                return singleEvent;
            }
        }
        return EKEvent.init();
    }
    
    func reloadFromNotification(jour: String) {
        self.jour = jour
        
        var row = 0
        while row < pickerData.count {
            if pickerData[row] == self.jour {
                self.datePicker.selectRow(row, inComponent: 0, animated: true)
                break;
            }
            row = row + 1
        }
        
        loadFilms()
        self.seancesTableView.reloadData()
    }
    
    @objc func tappedMovie(tapGestureRecognizer: SeanceTapGesture) {
        self.detailSeance = tapGestureRecognizer
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let navigation = segue.destination as? UINavigationController {
                let detailFilmVC = navigation.topViewController as? DetailFilmController
                if let detailFilmVC = detailFilmVC {
                    detailFilmVC.film = self.detailSeance.detail
                    detailFilmVC.jour = self.jour
                }
            }
        }
    }
}
