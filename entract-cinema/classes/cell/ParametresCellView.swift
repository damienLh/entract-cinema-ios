//
//  ParametresCellView.swift
//  yesvod
//
//  Created by Damien Lheuillier on 18/10/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import UIKit

class ParametresCellView: UITableViewCell {
    
    @IBOutlet weak var labelParametre: UILabel!
    
    @IBOutlet weak var labelValue: UILabel!
    
    @IBOutlet weak var btnParametre: UIButton!
    
    @IBAction func changeParametre(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
