//
//  Tools.swift
//  entract-cinema
//
//  Created by dlheuillier on 27/06/2018
//  Copyright © 2018 Entract. All rights reserved.
//

import UIKit

class Tools {
    
    static let shared = Tools()
    
    private init() {
    }

    func downloadImage(url: URL, imageView: UIImageView, activity: UIActivityIndicatorView) {
        activity.startAnimating()
        imageView.image = nil
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                activity.stopAnimating()
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func utf8(value :String)-> String {
        return value
    }
    
    func getTargetServer() -> String {
        var targetServer = Constants.remoteSite;
        var resourceFileDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            resourceFileDictionary = NSDictionary(contentsOfFile: path)
            targetServer = resourceFileDictionary?.object(forKey: "targetServer") as! String
        }
        return targetServer
    }
    
    func manageDuree(duree: String) -> String {
        let duration = duree.split(separator: "h")
        var result = duree
        
        let minute = Int(duration[1])
        if let minute = minute, minute < 10 {
            result = String("\(duration[0])h")
            result.append("0\(duration[1])")
        }
        
        return result
    }
    
    func isNetworkOrWifiAvailable() -> Bool {
        return NetworkUtils.isConnectedToNetwork()
    }
    
    @objc func offlineModeAlert(notification: NSNotification) {
        
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            UserDefaults.standard.set(true, forKey: "useCache")
        default:
            UserDefaults.standard.set(false, forKey: "useCache")
        }
        
        let alert = UIAlertController(title: "offlineModeTitle".localized(), message: "offlineModeMessage".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        if let notif = notification.object, notif is UIViewController, let vc = notif as? UIViewController {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func attributedTextWithImage(imageName: String) -> NSMutableAttributedString {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        
        if !Tools.shared.isDeviceHasHighScreen() {
            let imageOffsetY:CGFloat = -5.0;
            attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
        }
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        let result = NSMutableAttributedString()
        result.append(attachmentString)
        
        return result
    }
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    func isDeviceHasHighScreen() -> Bool {
        var result = false
        let modelName = UIDevice.modelName
        //if device is Plus model or iPhone X and higher
        if modelName.contains("Plus") || modelName.contains("X") {
            result = true
        }
        return result
    }
}
