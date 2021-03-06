//
//  LesHorairesTableViewController.swift
//  SidebarMenu
//
//  Created by administrateur on 24/11/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class LesHorairesTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var tableViewHoraires: UITableView!
    
    @IBOutlet weak var searchBarHoraires: UISearchBar!
    
    let titreFilm = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
    let troisD = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.red]
    let vo = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.blue]
    
    var items: [Semaine] = []
    
    var filteredData: [Semaine]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewHoraires.dataSource = self
        self.tableViewHoraires.delegate = self
        self.searchBarHoraires.delegate = self
        
        items = JSONUnparser.getProgramme()
        Statistiques.statProgramme()
        filteredData = items
        
        self.searchBarHoraires.setValue("Annuler", forKey:"_cancelButtonText")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBarHoraires.showsCancelButton=false
        self.searchBarHoraires.text = ""
        self.updateTableAccordingToSearchBar(searchText: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.searchBarHoraires.showsCancelButton=false
        self.searchBarHoraires.text = ""
        self.updateTableAccordingToSearchBar(searchText: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarHoraires.showsCancelButton=true
        self.updateTableAccordingToSearchBar(searchText: searchText)
    }
    
    func updateTableAccordingToSearchBar(searchText: String) {
        items = JSONUnparser.getProgramme()
        filteredData = items
        if !searchText.isEmpty {
            for semaine: Semaine in filteredData {
                for jour: Jours in semaine.jours {
                    for film: Film in jour.films {
                        if (!film.titre.lowercased().contains(searchText.lowercased())) {
                            let index = jour.films.firstIndex(of: film)!
                            jour.films.remove(at: index)
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height = CGFloat(0)
        let semaine = filteredData[section]
        
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
        let semaine = filteredData[indexPath.section]
        let joursLu = semaine.jours[indexPath.row]
        let content = NSMutableAttributedString()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let yesterday = Date().yesterday
        let jourCell = dateFormatter.date(from: joursLu.jour)
        
        var size = CGFloat(0)
        if joursLu.films.count != 0, jourCell! > yesterday {
            
           var firstFilm = true
           for film in joursLu.films {
                let contentFilm = NSMutableAttributedString()
                if !firstFilm {
                    contentFilm.append(NSMutableAttributedString(string:"\n\n", attributes:titreFilm))
                }
                firstFilm = false
                contentFilm.append(NSMutableAttributedString(string:"\(film.horaire) - ", attributes:titreFilm))
                contentFilm.append(NSMutableAttributedString(string:"\(film.titre) ", attributes:titreFilm))
            
                if film.troisD {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.threeD))
                }
                if film.vo {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.vost))
                }
            
                if film.avertissement {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.avertissement))
                } else if film.moinsDouze {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.moinsDouze))
                }
                content.append(contentFilm)
            }
            
            size = CGFloat(25.0)
            let test = content.mutableString.length
            let nbLines = CGFloat(round(Double(test / 30))) + CGFloat(joursLu.films.count)
            
            var remove = CGFloat(10.0)
            if joursLu.films.count > 1 {
                remove = CGFloat(joursLu.films.count) * CGFloat(10.0)
            }
            
            var mult = CGFloat(45.0)
            if joursLu.films.count > 1 {
                mult = CGFloat(35.0)
            }
 
            size = size + CGFloat(nbLines * mult) - remove
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
        let semaine = filteredData[section]
        
        headerCell.semaine.text = "Du \(semaine.debutsemaine.convertDateToDayMonth()) au \(semaine.finsemaine.convertDateToDayMonth())"
        headerCell.backgroundColor = .gray
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HorairesDateViewCell = tableView.dequeueReusableCell(withIdentifier: "horairesDateCell", for: indexPath) as! HorairesDateViewCell
    
        let semaine = filteredData[indexPath.section]
        let joursLu = semaine.jours[indexPath.row]
        cell.dateSeance.text = joursLu.jour.convertDateToLocaleDate()
        
        let content = NSMutableAttributedString()
        if joursLu.films.count == 0 {
            content.append(NSMutableAttributedString(string: "pas_de_film".localized(), attributes:titreFilm))
        } else {
            var firstFilm = true
            for film in joursLu.films {
                let contentFilm = NSMutableAttributedString()
                if !firstFilm {
                    contentFilm.append(NSMutableAttributedString(string:"\n\n", attributes:titreFilm))
                }
                firstFilm = false
                contentFilm.append(NSMutableAttributedString(string:"\(film.horaire) - ", attributes:titreFilm))
                contentFilm.append(NSMutableAttributedString(string:"\(film.titre) ", attributes:titreFilm))
                
                if film.troisD {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.threeD))
                }
                if film.vo {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.vost))
                }
                
                if film.avertissement {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.avertissement))
                } else if film.moinsDouze {
                    contentFilm.append(Tools.shared.attributedTextWithImage(imageName: Constants.moinsDouze))
                }
                content.append(contentFilm)
            }
        }
        cell.lesFilms.attributedText = content
        cell.lesFilms.textColor = Tools.shared.manageTheme()
        cell.backgroundColor = Tools.shared.manageWindowTheme()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let semaine = filteredData[indexPath.section]
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
