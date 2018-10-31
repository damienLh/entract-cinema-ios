//
//  TutorialViewController.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 02/07/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

class TutorialViewController : UIViewController {
    
    var myPicture: String = ""
    var currentPage: Int = 1
    
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picture.image = UIImage(named: myPicture)
        self.pageControl.currentPage = currentPage
        self.btnOK.isHidden = currentPage != 7
        self.pageControl.isHidden = currentPage == 7
    }
    
    @IBAction func fermer(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Constants.visualiserTuto)
        self.parent?.performSegue(withIdentifier: "goToApp", sender: self)
    }
}
