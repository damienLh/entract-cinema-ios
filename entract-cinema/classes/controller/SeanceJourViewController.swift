//
//  SeanceJourViewController.swift
//  L'entract
//
//  Created by dlheuillier on 27/06/2018
//  Copyright © 2018 Entract. All rights reserved.
//

import UIKit
import EventKit

class SeanceJourViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var seancesTableView: UITableView!
    
    var mapFilms: [String: [Film]]!
    var jour: String!
    var detailSeance: SeanceTapGesture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(Tools.shared.offlineModeAlert(notification:)), name: .flagsChanged, object: self)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        
        datePicker.minimumDate = dateFormatter.date(from: UserDefaults.standard.string(forKey: Constants.dateMin)!)
        datePicker.maximumDate = dateFormatter.date(from: UserDefaults.standard.string(forKey: Constants.dateMax)!)
        datePicker.addTarget(self, action: #selector(dateHasChange(_:)), for: UIControlEvents.valueChanged)
        self.jour = datePicker.date.toString.convertToDbData()
        self.seancesTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        loadFilms()
        self.seancesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self.jour)
        self.datePicker.date = date!
        
        loadFilms()
        self.seancesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        managePopup()
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.seancesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
                        annonceVC.providesPresentationContextTransitionStyle = true
                        annonceVC.definesPresentationContext = true
                        annonceVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
                        annonceVC.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
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
            let film = listeFilms[indexPath.row]
            
            if NetworkUtils.isWifiEnabled() || !UserDefaults.standard.bool(forKey: Constants.bandeAnnonceUniquementWIFI) {
                if let url = URL(string: film.affiche) {
                    seanceCell.afficheImageView.contentMode = .scaleAspectFit
                    Tools.shared.downloadImage(url: url, imageView: seanceCell.afficheImageView, activity: seanceCell.activityLoad)
                }
            } else {
                seanceCell.afficheImageView.image = UIImage(named: "seance_non_dispo")
            }
            
            seanceCell.titreLabel.text = film.titre
            
            let troisD = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.red]
            let vo = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.blue]
            let titreFilm = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.black]
            
            let content = NSMutableAttributedString()
            content.append(NSMutableAttributedString(string:"\(film.horaire) - ", attributes:titreFilm))
            content.append(NSMutableAttributedString(string:"\(film.duree) ", attributes:titreFilm))
                    
            if film.troisD {
                content.append(NSMutableAttributedString(string:"3D".localized(), attributes:troisD))
            }
            if film.vo {
                content.append(NSMutableAttributedString(string:"vo".localized(), attributes:vo))
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
                seanceCell.btnCalendrier.setTitle("alerte_film_ko".localized(), for: UIControlState.normal)
                seanceCell.btnCalendrier.setTitleColor(UIColor.red, for: UIControlState.normal)
                seanceCell.btnCalendrier.addGestureRecognizer(calendarGesture)
            } else {
                seanceCell.btnCalendrier.isUserInteractionEnabled = false
                seanceCell.btnCalendrier.setTitle("alerte_film_ok".localized(), for: UIControlState.normal)
                seanceCell.btnCalendrier.setTitleColor(UIColor(rgb: 0x2c8e40), for: UIControlState.normal)
            }
            
            cell = seanceCell
        } else {
            let noSeanceCell = tableView.dequeueReusableCell(withIdentifier: "noSeanceCell", for: indexPath) as! NoSeanceTableViewCell
            noSeanceCell.lblNoSeance.text = "pas_de_film".localized()
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
    
    @objc func dateHasChange(_ sender: UIDatePicker) {
        self.jour = sender.date.toString.convertToDbData()
        loadFilms()
        self.seancesTableView.reloadData()
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date,sender: UIButton, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                let valeurRappel = UserDefaults.standard.integer(forKey: Constants.tempsAlerte)
                print("valeur alarme \(valeurRappel)")
                
                let alarm:EKAlarm = EKAlarm(relativeOffset: TimeInterval(-60 * valeurRappel))
                event.alarms = [alarm]
                
                let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                let existingEvents = eventStore.events(matching: predicate)
                var alreadyExists = false
                for singleEvent in existingEvents {
                    if singleEvent.title == title {
                        alreadyExists = true
                        break
                    }
                }

                if !alreadyExists {
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let e as NSError {
                        completion?(false, e)
                        return
                    }
                    completion?(true, nil)
                    
                    let alert = UIAlertController(title: Constants.grenadeCinema, message: Constants.filmCalendrier, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        sender.setTitle("alerte_film_ok".localized(), for: UIControlState.normal)
                        sender.setTitleColor(UIColor(rgb: 0x2c8e40), for: UIControlState.normal)
                    }
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                completion?(false, error as NSError?)
                
                let alert = UIAlertController(title: Constants.grenadeCinema, message: Constants.calendarNotGranted, preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

    @objc func imageTapped(tapGestureRecognizer: SeanceTapGesture)
    {
        let calendar = Calendar.current
        let yearToday = calendar.component(.year, from: self.datePicker.date)
        let monthToday = calendar.component(.month, from: self.datePicker.date)
        let dayToday = calendar.component(.day, from: self.datePicker.date)
        
        let heure = tapGestureRecognizer.detail.horaire
        let film = tapGestureRecognizer.detail.titre
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
        
        addEventToCalendar(title: film, description: Constants.grenadeCinema, startDate: debut!, endDate: fin!, sender: tapGestureRecognizer.sender)
    }
    
    func isAlertFilmInCalendar(detail: Film) -> Bool {
        
        let eventStore = EKEventStore()
        let calendar = Calendar.current
        let yearToday = calendar.component(.year, from: self.datePicker.date)
        let monthToday = calendar.component(.month, from: self.datePicker.date)
        let dayToday = calendar.component(.day, from: self.datePicker.date)
        
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
            if singleEvent.title == film {
                alreadyExists = true
                break
            }
        }
        
        return alreadyExists
    }
    
    @objc func tappedMovie(tapGestureRecognizer: SeanceTapGesture) {
        self.detailSeance = tapGestureRecognizer
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let navigation = segue.destination as? UINavigationController {
                let detailFilmVC = navigation.topViewController as? TableViewDetailFilmController
                if let detailFilmVC = detailFilmVC {
                    detailFilmVC.film = self.detailSeance.detail
                    detailFilmVC.jour = self.jour
                }
            }
        }
    }
}
