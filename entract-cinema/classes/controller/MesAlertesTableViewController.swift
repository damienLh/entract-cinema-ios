//
//  MesAlertesTableViewController.swift
//  yefilm
//
//  Created by Damien Lheuillier on 09/05/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import UIKit
import EventKit

class MesAlertesTableViewController : UITableViewController {

    @IBOutlet var tableViewAlertes: UITableView!
    
    var lesAlertes: [Alertes]!
    let red = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : entractColor]
    let normal = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAlertes.dataSource = self
        self.tableViewAlertes.delegate = self
        
        if let cacheAlertes = Cache.shared.loadAlertes() {
            lesAlertes = cacheAlertes.alertes
        }
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableViewAlertes.tableHeaderView = UIView(frame: frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
            self.view.overrideUserInterfaceStyle = Tools.shared.manageTheme()
            Tools.shared.updateTabBar()
        }
        
        if let cacheAlertes = Cache.shared.loadAlertes() {
            lesAlertes = cacheAlertes.alertes
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lesAlertes.count > 0) ? lesAlertes.count : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (lesAlertes.count > 0) ? 0 :(self.view.frame.size.height - 120.0)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (lesAlertes.count > 0) ? 150.0 : 35.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> NoAlertCell? {
        /*let  headerCell = tableView.dequeueReusableCell(withIdentifier: "mesAlertesHeaderCell") as! MesAlertesHeaderCell*/
        
        let headerCell: NoAlertCell = tableView.dequeueReusableCell(withIdentifier: "noAlerteCell") as! NoAlertCell
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell: UITableViewCell
        
       // if lesAlertes.count > 0 {
            let alerte = lesAlertes[indexPath.row]
            let film = alerte.film
            
            let dataCell: MesAlertesCell = tableView.dequeueReusableCell(withIdentifier: "mesAlertesCell", for: indexPath) as! MesAlertesCell

            if NetworkUtils.isUserConnectedToWifi() || UserDefaults.standard.bool(forKey: Constants.displayAffiche) {
                if (!film.affiche.isEmpty) {
                    if let url = URL(string: film.affiche) {
                        Tools.shared.downloadAlamoFireImage(url: url, imageView: dataCell.affiche, activity: dataCell.activityLoad)
                        tableView.layoutSubviews()
                        tableView.layoutIfNeeded()
                    }
                } else {
                    dataCell.affiche.image = UIImage(named: "seance_non_dispo")
                }
            } else {
                dataCell.affiche.image = UIImage(named: "seance_non_dispo")
            }
            
            dataCell.affiche.layer.cornerRadius = 15.0
            dataCell.affiche.clipsToBounds = true
            dataCell.lesDonnees.attributedText = self.getAttributedTitle(date: alerte.jour, title: film.titre)
            dataCell.lblSynopsis.attributedText = getAttributedfilm(film: film)

            cell = dataCell
       return cell
   }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       let alerte = lesAlertes[indexPath.row]
       let film = alerte.film
       if let presentedViewController = (self.storyboard?.instantiateViewController(withIdentifier: "detailViewController")) as? DetailFilmController {
           presentedViewController.film = film
           presentedViewController.jour = alerte.jour
           presentedViewController.hideAlerte = true
           presentedViewController.providesPresentationContextTransitionStyle = true
           presentedViewController.definesPresentationContext = true
           presentedViewController.modalPresentationStyle = UIModalPresentationStyle.popover;
        
            presentedViewController.callback = { newValue in
                tableView.deselectRow(at: indexPath, animated: true)
            }
           self.present(presentedViewController, animated: true, completion: nil)
       }
   }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Supprimer"
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var eventStore = EKEventStore()
        var status = 0
        let alerte = self.lesAlertes[indexPath.row]
        
        if (editingStyle == .delete) {
            
            let group = DispatchGroup()
            group.enter()
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    eventStore = EKEventStore()

                    do {
                        let myEvent = self.getEventInCalendar(alerte: alerte);
                        let eventToRemove = eventStore.event(withIdentifier: myEvent.eventIdentifier);
                        try eventStore.remove(eventToRemove!, span: .thisEvent, commit: true)
                        self.manageAlerteInCache(myAlerte: alerte)
                    } catch _ as NSError {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        status = 2
                        group.leave()
                    }
                }
            })
            
            group.notify(queue: .main) {
                if status ==  2 {
                    Toast.show(message: "\("alerte_film_ko".localized()) pour \(alerte.film.titre)", controller: self, duration: 3.0, bottomPosition: -75.0)
                    
                    if let cacheAlertes = Cache.shared.loadAlertes() {
                        self.lesAlertes = cacheAlertes.alertes
                    }
                    self.tableView.reloadData()
                } else {
                    Toast.show(message: "calendarNotGranted".localized(), controller: self, duration: 5.0, bottomPosition: -75.0)
                }
            }
        }
    }
    
    func getAttributedTitle(date: String, title: String) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let gras = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor :entractColor]
        let titreF = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]

        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string:"\(date.convertDateToLocaleDate())\n", attributes:gras))
        content.append(NSMutableAttributedString(string:"\(title)", attributes:titreF))
        return content
    }
    
    func getAttributedfilm(film: Film) -> NSMutableAttributedString {
        let content = NSMutableAttributedString()
       
        content.append(NSMutableAttributedString(string:"\("de".localized())", attributes:red))
        if !film.de.isEmpty {
            content.append(NSMutableAttributedString(string:"\(film.de) \n", attributes:normal))
        } else {
            content.append(NSMutableAttributedString(string:"-\n", attributes:normal))
        }
        
        content.append(NSMutableAttributedString(string:"\("casting".localized())", attributes:red))
        if !film.avec.isEmpty {
            content.append(NSMutableAttributedString(string:"\(film.avec) \n", attributes:normal))
        }  else {
            content.append(NSMutableAttributedString(string:"-\n", attributes:normal))
        }

        content.append(NSMutableAttributedString(string:"\("duree".localized())", attributes:red))
        if !film.duree.isEmpty {
            content.append(NSMutableAttributedString(string:"\(film.duree) ", attributes:normal))
        }  else {
            content.append(NSMutableAttributedString(string:"-\n", attributes:normal))
        }
        
        return content
    }
    
    func manageAlerteInCache(myAlerte: Alertes) {
        if let cacheAlertes = Cache.shared.loadAlertes() {
            var alertes = cacheAlertes.alertes
            for alerte in alertes {
                if (alerte.film.titre == myAlerte.film.titre && alerte.jour == myAlerte.jour) {
                    if let index = alertes.firstIndex(of: alerte) {
                        alertes.remove(at: index)
                        break
                    }
                }
            }
            Cache.shared.saveAlertes(params: alertes)
        }
    }
    
    func getEventInCalendar(alerte: Alertes) -> EKEvent {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: alerte.jour)!
        
        let eventStore = EKEventStore()
        let calendar = Calendar.current
        let yearToday = calendar.component(.year, from: myDate)
        let monthToday = calendar.component(.month, from: myDate)
        let dayToday = calendar.component(.day, from: myDate)
        
        let film = alerte.film.titre
        let totalTime = 60
        
        var startFormat: String = String(format:"%d/%d/%d %@", yearToday, monthToday, dayToday, "09h00")
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
}
