//
//  LesHorairesTableViewController.swift
//  SidebarMenu
//
//  Created by administrateur on 24/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class LesHorairesTableViewController: UITableViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var tableViewHoraires: UITableView!
    
    var items: [Semaine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewHoraires.dataSource = self
        self.tableViewHoraires.delegate = self
        self.tableViewHoraires.rowHeight = UITableViewAutomaticDimension
        items = JSONUnparser.getProgramme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = JSONUnparser.getProgramme()
        self.tableViewHoraires.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height = CGFloat(0)
        let semaine = items[section]
        
        for jour in semaine.jours {
            if jour.films.count != 0 {
                height = CGFloat(45)
                break
            }
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let semaine = items[indexPath.section]
        let joursLu = semaine.jours[indexPath.row]
        let titreFilm = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.black]
        let content = NSMutableAttributedString()
        
        var size = CGFloat(0)
        if joursLu.films.count != 0 {
           for film in joursLu.films {
                content.append(NSMutableAttributedString(string:"\(film.horaire)\n", attributes:titreFilm))
                content.append(NSMutableAttributedString(string:"\(film.titre) ", attributes:titreFilm))
                content.append(NSMutableAttributedString(string:"\n", attributes:titreFilm))
            }
            
            if (joursLu.films.count > 1) {
                size = CGFloat(35.0)
                let test = content.mutableString.length
                let nbLines = CGFloat(round(Double(test / 35))) + CGFloat(joursLu.films.count)
                size = size + CGFloat(nbLines * 30.0)
            } else {
                size = CGFloat(40.0)
                let test = content.mutableString.length
                let nbLines = CGFloat(round(Double(test / 35))) + 1.0
                size = size + CGFloat(nbLines * 25.0)
            }
        }
        
        return size;
    }
    
    func getTableCell(_ indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "horairesCell", for: indexPath) as! HorairesTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "horairesDateCell", for: indexPath) as! HorairesDateViewCell
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> HorairesTableViewCell? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "horairesCell") as! HorairesTableViewCell
        let semaine = items[section]
        headerCell.semaine.text = "Du \(semaine.debutsemaine) au \(semaine.finsemaine)"
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HorairesDateViewCell = tableView.dequeueReusableCell(withIdentifier: "horairesDateCell", for: indexPath) as! HorairesDateViewCell
    
        let semaine = items[indexPath.section]
        let joursLu = semaine.jours[indexPath.row]
        
        cell.dateSeance.text = joursLu.jour
        let troisD = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.red]
        let vo = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.blue]
        let titreFilm = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let content = NSMutableAttributedString()
        if joursLu.films.count == 0 {
            content.append(NSMutableAttributedString(string: "Pas de séance ce jour", attributes:titreFilm))
        } else {
            for film in joursLu.films {
                content.append(NSMutableAttributedString(string:"\(film.horaire) - ", attributes:titreFilm))
                content.append(NSMutableAttributedString(string:"\(film.titre) ", attributes:titreFilm))
                
                if film.troisD {
                    content.append(NSMutableAttributedString(string:" 3D", attributes:troisD))
                }
                if film.vo {
                    content.append(NSMutableAttributedString(string:" VO", attributes:vo))
                }
                content.append(NSMutableAttributedString(string:"\n\n", attributes:titreFilm))
            }
        }
        cell.lesFilms.attributedText = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let semaine = items[indexPath.section]
        let joursLu: Jours = semaine.jours[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        let date = dateFormatter.date(from: joursLu.jour)
        let today = Date()
        
        if date! >= today {
            let seancesVC = tabBarController?.viewControllers![0] as! SeanceJourViewController
            seancesVC.jour = joursLu.jour
            tabBarController?.selectedIndex = 0
        }
    }
}
