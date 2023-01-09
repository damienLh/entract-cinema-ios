//
//  MesAlertesCell.swift
//  yesvod
//
//  Created by Damien Lheuillier on 09/05/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import UIKit

class MesAlertesCell: UITableViewCell {
    
    @IBOutlet weak var activityLoad: UIActivityIndicatorView!
    
    @IBOutlet weak var affiche: UIImageView!
    
    @IBOutlet weak var lesDonnees: UILabel!
    
    @IBOutlet weak var lblOriginals: UILabel!
    
    @IBOutlet weak var lblSynopsis: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(1.0)
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height - mSeparatorHeight, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = entractColor
        self.addSubview(mAddSeparator)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
