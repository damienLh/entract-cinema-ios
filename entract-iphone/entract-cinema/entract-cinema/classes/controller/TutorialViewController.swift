//
//  TutorialViewController.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 02/07/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

class TutorialViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func fermer(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Constants.visualiserTuto)
        self.dismiss(animated: true, completion: nil)
    }
}
