//
//  TableViewDetailFilmController.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 31/08/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

class TableViewDetailFilmController : UITableViewController {
    
    @IBOutlet var tableViewDetail: UITableView!
    
    var film: Film = Film()
    var jour: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDetail.dataSource = self
        self.tableViewDetail.delegate = self
        Statistiques.statDetailFilm(jour: jour, titreFilm: film.id_film)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 790.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewCell? {
        let headerTitre = tableView.dequeueReusableCell(withIdentifier: "headerTitreCell") as! HeaderTitreCell
        headerTitre.lblTitre.text = film.titre
        return headerTitre
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let posterCell = tableView.dequeueReusableCell(withIdentifier: "posterCell", for: indexPath) as! PosterCell
        
            posterCell.lblPays.attributedText = getAttributedText(title: "Pays", value: film.pays)
            posterCell.lblAnneeDuree.attributedText = getAttributedFirstLine(annee: film.annee, duree: film.duree)
            posterCell.lblGenre.attributedText = getAttributedText(title: "Genre", value: film.style)
            posterCell.lblAvec.attributedText = getAttributedText(title: "Avec", value: Tools.shared.utf8(value: film.avec))
            posterCell.lblDe.attributedText = getAttributedText(title: "De", value: Tools.shared.utf8(value: film.de))
            posterCell.lblSynopsis.attributedText = getAttributedSynopsis(value: film.synopsis)
            posterCell.lblSynopsis.sizeToFit()
            posterCell.btnBandeAnnonce.isHidden = true
        
            if NetworkUtils.isWifiEnabled() || !UserDefaults.standard.bool(forKey: Constants.bandeAnnonceUniquementWIFI) {
                if let url = URL(string: film.affiche) {
                    posterCell.affiche.contentMode = .scaleAspectFit
                    Tools.shared.downloadImage(url: url, imageView: posterCell.affiche, activity: posterCell.activity)
                }
                
                posterCell.btnBandeAnnonce.isHidden = film.bandeAnnonce.isEmpty
            } else {
                posterCell.affiche.image = UIImage(named: "seance_non_dispo")
            }
        
            posterCell.btnBandeAnnonce.addTarget(self, action: #selector(launchBandeAnnonce(_:)), for: .touchUpInside)

        return posterCell
    }
    
    @objc func launchBandeAnnonce(_ sender: UIButton) {
        let youtubeId = film.bandeAnnonce
        var url = URL(string:"youtube://\(youtubeId)")!
        if !UIApplication.shared.canOpenURL(url)  {
            url = URL(string:"http://www.youtube.com/watch?v=\(youtubeId)")!
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func getAttributedFirstLine(annee: String, duree: String)->NSMutableAttributedString {
        let gras = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.black]
        let normal = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.gray]
        
        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string:"Année ", attributes:gras))
        content.append(NSMutableAttributedString(string:"\(annee) ", attributes:normal))
        content.append(NSMutableAttributedString(string:" Durée ", attributes:gras))
        content.append(NSMutableAttributedString(string:"\(duree) ", attributes:normal))
        return content
    }

    
    func getAttributedText(title: String, value: String)->NSMutableAttributedString {
        let gras = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.black]
        let normal = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.gray]
        
        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string:"\(title) ", attributes:gras))
        content.append(NSMutableAttributedString(string:"\(value) ", attributes:normal))
        return content
    }
    
    func getAttributedSynopsis(value: String) -> NSMutableAttributedString {
        let red = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.red]
        let normal = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.gray]
        
        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string:"SYNOPSIS\n", attributes:red))
        content.append(NSMutableAttributedString(string:"\(value) ", attributes:normal))
        return content
    }
}
