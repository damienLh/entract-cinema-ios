//
//  PosterCell.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 31/08/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

class PosterCell : UITableViewCell {
    
    @IBOutlet weak var affiche: UIImageView!
    
    @IBOutlet weak var lblPays: UILabel!
    
    @IBOutlet weak var lblAnneeDuree: UILabel!
    
    @IBOutlet weak var lblGenre: UILabel!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var lblAvec: UILabel!
    
    @IBOutlet weak var lblDe: UILabel!
    
    @IBOutlet weak var lblSynopsis: UILabel!
    
    @IBOutlet weak var btnBandeAnnonce: UIButton!
}
