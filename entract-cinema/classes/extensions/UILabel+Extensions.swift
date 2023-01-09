//
//  UILabel+Extensions.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 06/11/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit

extension UILabel
{
    func addImage(imageName: String)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        
        if !Tools.shared.isDeviceHasHighScreen() {
            let imageOffsetY:CGFloat = -5.0;
            attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
        }
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let result = NSMutableAttributedString()
        result.append(self.attributedText!)
        result.append(attachmentString)
        
        self.attributedText = result
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
