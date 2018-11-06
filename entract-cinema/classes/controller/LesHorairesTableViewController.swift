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
        items = JSONUnparser.getProgramme()
        Statistiques.statProgramme()
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
        let titreFilm = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
        let content = NSMutableAttributedString()
        
        var size = CGFloat(0)
        if joursLu.films.count != 0 {
            
           var firstFilm = true
           for film in joursLu.films {
                if !firstFilm {
                    content.append(NSMutableAttributedString(string:"\n\n", attributes:titreFilm))
                }
                firstFilm = false
                content.append(NSMutableAttributedString(string:"\(film.horaire) - ", attributes:titreFilm))
                content.append(NSMutableAttributedString(string:"\(film.titre) ", attributes:titreFilm))
                if film.troisD {
                    content.append(NSMutableAttributedString(string:"3D".localized(), attributes:titreFilm))
                }
                if film.vo {
                    content.append(NSMutableAttributedString(string:"vo".localized(), attributes:titreFilm))
                }
            
                if film.avertissement {
                    content.append(NSMutableAttributedString(string:"avertissement".localized(), attributes:titreFilm))
                }
            
                if film.moinsDouze {
                    content.append(NSMutableAttributedString(string:"moinsDouze".localized(), attributes:titreFilm))
                }
            }
            
            size = CGFloat(25.0)
            let test = content.mutableString.length
            let nbLines = CGFloat(round(Double(test / 30))) + CGFloat(joursLu.films.count)
            
            var remove = CGFloat(10.0)
            if joursLu.films.count > 1 {
                remove = CGFloat(joursLu.films.count) * CGFloat(10.0)
            }
 
            size = size + CGFloat(nbLines * 35.0) - remove
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
        
        headerCell.semaine.text = "Du \(semaine.debutsemaine.convertDateToDayMonth()) au \(semaine.finsemaine.convertDateToDayMonth())"
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HorairesDateViewCell = tableView.dequeueReusableCell(withIdentifier: "horairesDateCell", for: indexPath) as! HorairesDateViewCell
    
        let semaine = items[indexPath.section]
        let joursLu = semaine.jours[indexPath.row]
        cell.dateSeance.text = joursLu.jour.convertDateToLocaleDate()
        
        let troisD = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.red]
        let vo = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.blue]
        let titreFilm = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let content = NSMutableAttributedString()
        if joursLu.films.count == 0 {
            content.append(NSMutableAttributedString(string: "pas_de_film".localized(), attributes:titreFilm))
        } else {
            var firstFilm = true
            for film in joursLu.films {
                if !firstFilm {
                    content.append(NSMutableAttributedString(string:"\n\n", attributes:titreFilm))
                }
                firstFilm = false
                content.append(NSMutableAttributedString(string:"\(film.horaire) - ", attributes:titreFilm))
                content.append(NSMutableAttributedString(string:"\(film.titre) ", attributes:titreFilm))
                
                if film.troisD {
                    content.append(NSMutableAttributedString(string:"3D".localized(), attributes:troisD))
                }
                if film.vo {
                    content.append(NSMutableAttributedString(string:"vo".localized(), attributes:vo))
                }
                
                if film.avertissement {
                    content.append(NSMutableAttributedString(string:"avertissement".localized(), attributes:titreFilm))
                }
                
                if film.moinsDouze {
                    content.append(NSMutableAttributedString(string:"moinsDouze".localized(), attributes:titreFilm))
                }
            }
        }
        cell.lesFilms.attributedText = content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let yesterday = Date().yesterday
        let jourCell = dateFormatter.date(from: joursLu.jour)
        if jourCell! <= yesterday {
            cell.backgroundColor = UIColor.init(red: 179, green: 179, blue: 179)
        } else {
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let semaine = items[indexPath.section]
        let joursLu: Jours = semaine.jours[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        if joursLu.jour >= today {
            let seancesVC = tabBarController?.viewControllers![0] as! SeanceJourViewController
            seancesVC.reloadFromNotification(jour: joursLu.jour)
            tabBarController?.selectedIndex = 0
        }
    }
}
