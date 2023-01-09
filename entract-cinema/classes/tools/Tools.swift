//
//  Tools.swift
//  entract-cinema
//
//  Created by dlheuillier on 27/06/2018
//  Copyright © 2018 Entract. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Tools {
    
    static let shared = Tools()
    
    private init() {
    }
    
    func downloadAlamoFireImage(url: URL, imageView: UIImageView, activity: UIActivityIndicatorView) {
        activity.startAnimating()
        let placeholder = UIImage(named: "seance_non_dispo")
        imageView.af.setImage(withURL: url, placeholderImage: placeholder)
        imageView.contentMode = .scaleToFill
        activity.stopAnimating()
    }
    
    func downloadAlamoFireImageNoAnimation(url: URL, imageView: UIImageView) {
        let placeholder = UIImage(named: "seance_non_dispo")
        imageView.af.setImage(withURL: url, placeholderImage: placeholder)
        imageView.contentMode = .scaleToFill
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
        
       // if !Tools.shared.isDeviceHasHighScreen() {
            let imageOffsetY:CGFloat = -5.0;
            attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
       // }
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
    
    func darkModeActivated() -> Bool {
        let darkMode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
        return darkMode == "Dark"
    }
    
    func darkModeActivatedForLogo() -> Bool {
        let theme = UserDefaults.standard.string(forKey: Constants.afficherThemeSombre)
        switch theme {
        case "dark":
            return true
        case "auto":
            return (self.darkModeActivated()) ? true : false;
        default:
            return false
        }
    }
    
    @available(iOS 13, *)
    func manageTheme() -> UIUserInterfaceStyle {
        let theme = UserDefaults.standard.string(forKey: Constants.afficherThemeSombre)
        switch theme {
        case "dark":
            return UIUserInterfaceStyle.dark
        case "auto":
            return (self.darkModeActivated()) ? UIUserInterfaceStyle.dark : UIUserInterfaceStyle.light;
        default:
            return UIUserInterfaceStyle.light
        }
    }
    
    @available(iOS 13, *)
    func borderStyleAccordingTheme() -> CGColor {
        let theme = UserDefaults.standard.string(forKey: Constants.afficherThemeSombre)
        switch theme {
        case "dark":
            return UIColor.white.cgColor
        case "auto":
            return (self.darkModeActivated()) ? UIColor.white.cgColor : UIColor.black.cgColor;
        default:
            return UIColor.black.cgColor
        }
    }
    
    @available(iOS 13, *)
    func textColorAccordingTheme() -> UIColor {
        let theme = UserDefaults.standard.string(forKey: Constants.afficherThemeSombre)
        switch theme {
        case "dark":
            return .white
        case "auto":
            return (self.darkModeActivated()) ? .white : .black;
        default:
            return .black
        }
    }
    
    @available(iOS 13, *)
    func manageTabBarTheme() -> UIColor {
        let theme = UserDefaults.standard.string(forKey: Constants.afficherThemeSombre)
        switch theme {
        case "dark":
            return .black
        case "auto":
            if self.darkModeActivated() {
                return .black;
            } else {
                return .white;
            }
        default:
            return .white
        }
    }
    
    func updateTabBar() {
     //maj du background de la tabbar
      if #available(iOS 13, *) {
          guard let currentView = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view,
              let superview = currentView.superview else { return }
          UITabBar.appearance().barTintColor = Tools.shared.manageTabBarTheme()
          currentView.removeFromSuperview()
          superview.addSubview(currentView)
      }
    }
}
