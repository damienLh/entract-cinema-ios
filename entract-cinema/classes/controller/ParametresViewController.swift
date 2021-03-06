//
//  ParametresViewController.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 02/07/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

class ParametresViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lblThemeSombre: UILabel!
    
    @IBOutlet weak var lblEvenement: UILabel!
    
    @IBOutlet weak var lblWifi: UILabel!
    
    @IBOutlet weak var lblAlerte: UILabel!
    
    @IBOutlet weak var switchThemeSombre: UISwitch!
    
    @IBOutlet weak var pickerAlerte: UIPickerView!
    
    @IBOutlet weak var switchEvenement: UISwitch!
    
    @IBOutlet weak var switchBandeAnnonce: UISwitch!
    
    @IBOutlet weak var lblInfosAlertes: UILabel!
    
    var pickerData: [String] = [String]()
    var pickerTitle: [String] = [String]()    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.pickerAlerte.delegate = self
        self.pickerAlerte.dataSource = self
        
        // Initialize Data
        pickerData = ["30", "60", "120", "180", "240"];
        pickerTitle = ["30min".localized(), "60min".localized(), "120min".localized(), "180min".localized(), "240min".localized()];
        
        let time = UserDefaults.standard.integer(forKey: Constants.tempsAlerte)
        var row = 0
        switch time {
        case 30:
            row = 0
        case 60:
            row = 1
        case 180:
            row = 3
        case 240:
            row = 4
        default:
            row = 2
        }
        
        self.pickerAlerte.selectRow(row, inComponent: 0, animated: true)
        let value = pickerTitle[row]
        self.lblInfosAlertes.text = String(format: NSLocalizedString("infoAlerteFixed", comment: ""), value.localized())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manageTheme()
        self.switchThemeSombre.isOn = UserDefaults.standard.bool(forKey: Constants.afficherThemeSombre)
        self.switchEvenement.isOn = UserDefaults.standard.bool(forKey: Constants.autoriserAnnonce)
        self.switchBandeAnnonce.isOn = UserDefaults.standard.bool(forKey: Constants.bandeAnnonceUniquementWIFI)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var color:UIColor = .black
        if UserDefaults.standard.bool(forKey: Constants.afficherThemeSombre) {
            color = .white
        }
        
        let attributedString = NSAttributedString(string: pickerTitle[row], attributes: [NSAttributedString.Key.foregroundColor : color])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let time = pickerData[row]
        let value = pickerTitle[row]
        self.lblInfosAlertes.text = String(format: NSLocalizedString("infoAlerteFixed", comment: ""), value.localized())
        
        UserDefaults.standard.set(time, forKey: Constants.tempsAlerte)
    }
    
    func manageTheme() {
        self.lblThemeSombre.textColor = Tools.shared.manageTheme()
        self.lblEvenement.textColor = Tools.shared.manageTheme()
        self.lblWifi.textColor = Tools.shared.manageTheme()
        self.lblAlerte.textColor = Tools.shared.manageTheme()
        self.lblInfosAlertes.textColor = Tools.shared.manageTheme()
        self.view.backgroundColor = Tools.shared.manageWindowTheme()
        self.pickerAlerte.backgroundColor = Tools.shared.manageWindowTheme()
        self.pickerAlerte.reloadAllComponents()
    }
    
    @IBAction func switchThemeChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.afficherThemeSombre)
        manageTheme()
    }
    
    @IBAction func switchAnnonceChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.autoriserAnnonce)
    }
    
    @IBAction func switchBAAutorisedChanged(_ sender: UISwitch) {
        if !sender.isOn {
            let alertController = UIAlertController(title: "data_titre".localized(), message: "data_content".localized(), preferredStyle: .alert)
            
            let actionOK = UIAlertAction(title: "continuer".localized(), style: .default) { (action:UIAlertAction) in
                UserDefaults.standard.set(false, forKey: Constants.bandeAnnonceUniquementWIFI)
                self.switchBandeAnnonce.isOn = false
            }
            
            let actionCancel = UIAlertAction(title: "annuler".localized(), style: .cancel) { (action:UIAlertAction) in
                UserDefaults.standard.set(true, forKey: Constants.bandeAnnonceUniquementWIFI)
                self.switchBandeAnnonce.isOn = true
            }
            
            alertController.addAction(actionCancel)
            alertController.addAction(actionOK)
            self.present(alertController, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(true, forKey: Constants.bandeAnnonceUniquementWIFI)
        }
    }
}
