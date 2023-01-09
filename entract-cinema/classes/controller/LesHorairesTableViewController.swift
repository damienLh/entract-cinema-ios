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
        
    let titreFilm = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
    let troisD = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.red]
    let vo = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.blue]
    
    var items: [Semaine] = []
    var filteredData: [Semaine]!
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewHoraires.dataSource = self
        self.tableViewHoraires.delegate = self
        
        items = JSONUnparser.getProgramme()
        Statistiques.statProgramme()
        filteredData = items
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annuler"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher film"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        var height = CGFloat(0)
        let semaine = filteredData[indexPath.section]
        
        for jour in semaine.jours {
            if jour.films.count != 0 {
                height = CGFloat(145)
                break
            }
        }
        
        return height
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
        cell.infoFilm.attributedText = content
        
        if NetworkUtils.isUserConnectedToWifi() || UserDefaults.standard.bool(forKey: Constants.displayAffiche) {
            if let url = URL(string: film.affiche) {
                cell.imageSeance.contentMode = .scaleAspectFit
                Tools.shared.downloadImage(url: url, imageView: cell.imageSeance, activity: cell.activityLoad)
            }
        } else {
            seanceCell.afficheImageView.image = UIImage(named: "seance_non_dispo")
        }
        
        
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
    
    // MARK: - Search view data source
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.updateTableAccordingToSearchBar(searchText: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateTableAccordingToSearchBar(searchText: searchText)
    }
    
    func updateTableAccordingToSearchBar(searchText: String) {
        items = JSONUnparser.getProgramme()
        self.filteredData = self.items
        if !searchText.isEmpty {
            for semaine: Semaine in filteredData {
                let semaineIndex = filteredData.firstIndex(of: semaine)!
                for jour: Jours in semaine.jours {
                    for film: Film in jour.films {
                        if (!film.titre.lowercased().contains(searchText.lowercased())) {
                            let index = jour.films.firstIndex(of: film)!
                            jour.films.remove(at: index)
                        }
                    }
                    
                    if (semaine.jours.count == 0) {
                        filteredData.remove(at: semaineIndex)
                    }
                }
            }
        }
        
        if (searchText.isEmpty) {
            self.filteredData = self.items
        }
        tableView.reloadData()
    }
}

extension LesHorairesTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    updateTableAccordingToSearchBar(searchText: searchBar.text!)
  }
}
