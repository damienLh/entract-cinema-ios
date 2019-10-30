//
//  SeanceTableViewCell.swift
//  SidebarMenu
//
//  Created by Damien Lheuillier on 26/05/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class SeanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var afficheImageView: UIImageView!
    
    @IBOutlet weak var titreLabel: UILabel!

    @IBOutlet weak var infosFilm: UILabel!
    
    @IBOutlet weak var btnCalendrier: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var activityLoad: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
