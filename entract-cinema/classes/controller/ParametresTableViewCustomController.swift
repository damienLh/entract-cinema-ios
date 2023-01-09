//
//  ParametresTableViewCustomController.swift
//  yesvod
//
//  Created by Damien Lheuillier on 20/10/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import UIKit

class ParametresTableViewCustomController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    
    var parametre: Parametre = Parametre()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.myTableView.tableHeaderView = UIView(frame: frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
            self.view.overrideUserInterfaceStyle = Tools.shared.manageTheme()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parametre.values.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> ParametresCustomHeaderCell? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "parametresCustemHeaderCell") as! ParametresCustomHeaderCell
        
        headerCell.lblTitreCategorie.text = self.parametre.label

        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parametresCustemCell", for: indexPath) as! ParametresCustemCell
        let value = self.parametre.values[indexPath.row];
        let valueType = self.parametre.valuesType[indexPath.row];

        let storage = self.parametre.storage
        let storageType = self.parametre.storageType
        
        cell.tickImageView.isHidden = true;
        if storageType == "bool" {
            let storageValue = UserDefaults.standard.bool(forKey: storage);
            if convertToBool(value: (valueType as? String)!) == storageValue {
                cell.tickImageView.isHidden = false
            }
        } else if storageType == "string" {
            let storageValue = UserDefaults.standard.string(forKey: storage);
            if valueType as? String == storageValue {
                cell.tickImageView.isHidden = false
            }
        }
        cell.lblParametreOption.text = value;
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valueType = self.parametre.valuesType[indexPath.row];
        let storage = self.parametre.storage
        UserDefaults.standard.set(valueType, forKey: storage)
        self.myTableView.reloadData()
    }
    
    func convertToBool(value: String) -> Bool {
        return (value == "YES")  ? true : false;
    }
}
