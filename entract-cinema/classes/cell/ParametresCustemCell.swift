//
//  ParametresCustemCell.swift
//  yesvod
//
//  Created by Damien Lheuillier on 20/10/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import UIKit

class ParametresCustemCell: UITableViewCell {
    
    
    @IBOutlet weak var lblParametreOption: UILabel!
    
    @IBOutlet weak var tickImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
