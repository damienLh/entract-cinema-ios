//
//  ParametresTableViewController.swift
//  yesvod
//
//  Created by Damien Lheuillier on 18/10/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import UIKit

class ParametresTableViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    
    var parametres: [Parametre] = []
    var selectedParametre = Parametre()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
         if let path = Bundle.main.path(forResource: "parametres", ofType: "plist") {
            let dictionary = NSDictionary(contentsOfFile: path)!
            
            let sortedKeys = dictionary.allKeys.sorted { ($0 as AnyObject).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }

            for (key) in sortedKeys {
                let parametre = dictionary[key] as! NSDictionary
                let myParam = Parametre()
                myParam.label = (parametre["label"] as! NSString) as String
                myParam.storage = (parametre["storage"] as! NSString) as String
                myParam.storageType = (parametre["storageType"] as! NSString) as String
                myParam.values = (parametre["values"] as! NSArray) as! [String]
                myParam.valuesType = (parametre["valuesType"] as! NSArray) as! [Any]
                self.parametres.append(myParam)
            }
         }
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.myTableView.tableHeaderView = UIView(frame: frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
            self.view.overrideUserInterfaceStyle = Tools.shared.manageTheme()
            Tools.shared.updateTabBar()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 13, *) {
            self.view.overrideUserInterfaceStyle = Tools.shared.manageTheme()
            Tools.shared.updateTabBar()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parametres.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "parametresCellView", for: indexPath) as! ParametresCellView
        
        let parametre = self.parametres[indexPath.row]
        cell.labelParametre.text = parametre.label
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedParametre = self.parametres[indexPath.row];
        self.performSegue(withIdentifier: "segueCustomParam", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCustomParam" {
            if let destinationVC = segue.destination as? ParametresTableViewCustomController {
                destinationVC.parametre = self.selectedParametre
            }
        }
    }
}
