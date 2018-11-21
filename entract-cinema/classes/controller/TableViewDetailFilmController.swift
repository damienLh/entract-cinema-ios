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
    var myCustomHeight = CGFloat(0.0)
    
    let red = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : entractColor]
    let normal = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.gray]
    let gras = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
    let grasMessage = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDetail.dataSource = self
        self.tableViewDetail.delegate = self
        Statistiques.statDetailFilm(jour: jour, idFilm: film.id_film)
        
        if Tools.shared.SYSTEM_VERSION_LESS_THAN(version: "11.0") {
            self.tableViewDetail.contentOffset = CGPoint(x: 0.0, y: 65.0)
            self.tableViewDetail.contentInset = UIEdgeInsets(top: 65.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return film.autresDates.count == 0 ? 1 : film.autresDates.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewCell? {
        let headerTitre = tableView.dequeueReusableCell(withIdentifier: "headerTitreCell") as! HeaderTitreCell
        if section == 0 {
           let titreContent = NSMutableAttributedString()
            titreContent.append(NSMutableAttributedString(string:"\(film.titre) ", attributes:red))
            
            if film.troisD {
                titreContent.append(Tools.shared.attributedTextWithImage(imageName: Constants.threeD))
            }
            if film.vo {
                titreContent.append(Tools.shared.attributedTextWithImage(imageName: Constants.vost))
            }
            
            headerTitre.lblTitre.attributedText = titreContent
        } else {
            let titreContent = NSMutableAttributedString()
            titreContent.append(NSMutableAttributedString(string:"autresSeances".localized(), attributes:red))
            headerTitre.lblTitre.attributedText = titreContent
        }
        return headerTitre
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.myCustomHeight != CGFloat(0.0) ? self.myCustomHeight : CGFloat(790.0)
        }
        return CGFloat(45.0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var myCell: UITableViewCell
        if indexPath.section == 0 {
            let posterCell = tableView.dequeueReusableCell(withIdentifier: "posterCell", for: indexPath) as! PosterCell
            
            posterCell.lblPays.attributedText = getAttributedText(title: "pays".localized(), value: film.pays)
            posterCell.lblAnneeDuree.attributedText = getAttributedFirstLine(annee: film.annee, duree: film.duree)
            
            posterCell.lblGenre.attributedText = getAttributedText(title: "genre".localized(), value: film.style)
            posterCell.lblAvec.attributedText = getAttributedText(title: "avec".localized(), value: Tools.shared.utf8(value: film.avec))
            posterCell.lblDe.attributedText = getAttributedText(title: "de".localized(), value: Tools.shared.utf8(value: film.de))
            posterCell.lblSynopsis.attributedText = getAttributedSynopsis(value: film.synopsis)
            posterCell.lblSynopsis.sizeToFit()
            posterCell.btnBandeAnnonce.isHidden = true
            
            if NetworkUtils.isUserConnectedToWifi() || !UserDefaults.standard.bool(forKey: Constants.bandeAnnonceUniquementWIFI) {
                if let url = URL(string: film.affiche) {
                    posterCell.affiche.contentMode = .scaleAspectFit
                    Tools.shared.downloadImage(url: url, imageView: posterCell.affiche, activity: posterCell.activity)
                }
                
                posterCell.btnBandeAnnonce.isHidden = film.bandeAnnonce.isEmpty
            } else {
                posterCell.affiche.image = UIImage(named: "seance_non_dispo")
            }
            
            posterCell.btnBandeAnnonce.addTarget(self, action: #selector(launchBandeAnnonce(_:)), for: .touchUpInside)
            
            let height = CGFloat(posterCell.lblSynopsis.frame.size.height) + 25
            let viewHeight = CGFloat(550) + CGFloat(height)
            self.myCustomHeight = viewHeight
            //self.tableViewDetail.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            myCell = posterCell
        } else {
            let footer = tableView.dequeueReusableCell(withIdentifier: "autresDatesCell") as! AutresDatesCell
            footer.lblAutresSeances.text = "derniereSeance".localized()
            footer.lblAutresSeances.isUserInteractionEnabled = false

            if film.autresDates.count > 0 {
                let autreDate = film.autresDates[indexPath.row]
                footer.lblAutresSeances.attributedText = getAttributedTextAutresSeances(autreDate: autreDate)

                let tapAutreDate = AutreDateTapGesture(target: self, action: #selector(onClickAutresSeances(sender:)))
                tapAutreDate.jour = autreDate.date
                footer.lblAutresSeances.isUserInteractionEnabled = true
                footer.lblAutresSeances.addGestureRecognizer(tapAutreDate)
            }
            myCell = footer
        }
        return myCell
    }
    
    @objc func onClickAutresSeances(sender:AutreDateTapGesture) {
        self.dismiss(animated: true, completion: nil)
        
        if self.parent?.presentingViewController is UINavigationController {
            let navBar = self.parent?.presentingViewController as! UINavigationController
            if navBar.children.count > 1, navBar.children[1] is UITabBarController {
                let tabBar = navBar.children[1] as! UITabBarController
                for vc in tabBar.viewControllers! {
                    if vc is SeanceJourViewController {
                        let seancesVC = vc as! SeanceJourViewController
                        seancesVC.reloadFromNotification(jour: sender.jour)
                    }
                }
            }
        }
    }
    
    @objc func launchBandeAnnonce(_ sender: UIButton) {
        let youtubeId = film.bandeAnnonce
        var url = URL(string:"youtube://\(youtubeId)")!
        if !UIApplication.shared.canOpenURL(url)  {
            url = URL(string:"http://www.youtube.com/watch?v=\(youtubeId)")!
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func getAttributedFirstLine(annee: String, duree: String)->NSMutableAttributedString {
        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string:"annee".localized(), attributes:gras))
        content.append(NSMutableAttributedString(string:"\(annee) ", attributes:normal))
        content.append(NSMutableAttributedString(string:"duree".localized(), attributes:gras))
        content.append(NSMutableAttributedString(string:"\(duree) ", attributes:normal))
        
        let afficherArtEssai = UserDefaults.standard.bool(forKey: Constants.afficherInfoArtEssai)

        if film.artEssai, afficherArtEssai{
            content.append(NSMutableAttributedString(string:"   \("artEssai".localized())\n", attributes:red))
        }
        return content
    }

    func getAttributedText(title: String, value: String)->NSMutableAttributedString {
        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string:"\(title) ", attributes:gras))
        content.append(NSMutableAttributedString(string:"\(value) ", attributes:normal))
        return content
    }
    
    func getAttributedSynopsis(value: String) -> NSMutableAttributedString {
        let content = NSMutableAttributedString()
        content.append(NSMutableAttributedString(string:"\("synopsis".localized())\n", attributes:red))
        content.append(NSMutableAttributedString(string:"\(value) ", attributes:normal))
        
        if film.avertissement {
            content.append(NSMutableAttributedString(string:"\n\n\("messageAvertissement".localized())", attributes:grasMessage))
        }
        
        if film.moinsDouze {
            content.append(NSMutableAttributedString(string:"\n\n\("messageMoinsDouze".localized())", attributes:grasMessage))
        }

        return content
    }
    
    func getAttributedTextAutresSeances(autreDate: AutresDates)->NSMutableAttributedString {
        let content = NSMutableAttributedString()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        
        let completeDateFormatter = DateFormatter()
        completeDateFormatter.dateFormat =  "EEEE dd LLLL"
        completeDateFormatter.locale = Locale(identifier: "fr")
        
        let dateJour = dateFormatter.date(from: autreDate.date)
        content.append(NSMutableAttributedString(string:"\(completeDateFormatter.string(from: dateJour!)) - \(autreDate.horaire) ", attributes:normal))
        
        if autreDate.troisD {
            content.append(Tools.shared.attributedTextWithImage(imageName: Constants.threeD))
        }
        if autreDate.vo {
            content.append(Tools.shared.attributedTextWithImage(imageName: Constants.vost))
        }
        
        return content
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
