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
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        
        let imageOffsetY:CGFloat = -5.0;
        attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
