//
//  AfficheEvenementViewController.swift
//  entract-cinema
//
//  Created by LHEUILLIER Damien (i-BP - INFOTEL) on 04/07/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

class AfficheEvenementViewController : UIViewController {
    
    var annonce: String = ""
    
    @IBOutlet weak var annonceImageView: UIImageView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBAction func fermer(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: Constants.displayAffiche)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
        if let url = URL(string: annonce) {
            self.annonceImageView.contentMode = .scaleAspectFit
            Tools.shared.downloadImage(url: url, imageView: self.annonceImageView, activity: activity)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
            self.view.overrideUserInterfaceStyle = Tools.shared.manageTheme()
        }
    }
}
