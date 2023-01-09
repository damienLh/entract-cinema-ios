//
//  FooterTableViewHeaderCell.swift
//  yesvod
//
//  Created by Damien Lheuillier on 09/11/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import UIKit

class FooterTableViewHeaderCell: UITableViewCell {
        
    @IBOutlet weak var btnGoTop: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
