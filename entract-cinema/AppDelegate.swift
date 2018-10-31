//
//  AppDelegate.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 06/06/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Thread.sleep(forTimeInterval: 1.0)
        //creation du dictionnaire cache
        Cache.shared.defineDictionnary()
        
        if UserDefaults.standard.object(forKey: Constants.tempsAlerte) == nil {
            UserDefaults.standard.set(120, forKey: Constants.tempsAlerte)
        }
        
        if UserDefaults.standard.object(forKey: Constants.visualiserTuto) == nil {
            UserDefaults.standard.set(true, forKey: Constants.visualiserTuto)
        }
        
        if UserDefaults.standard.object(forKey: Constants.bandeAnnonceUniquementWIFI) == nil {
            UserDefaults.standard.set(false, forKey: Constants.bandeAnnonceUniquementWIFI)
        }
        
        if UserDefaults.standard.object(forKey: Constants.autoriserAnnonce) == nil {
            UserDefaults.standard.set(true, forKey: Constants.autoriserAnnonce)
        }
        
        if UserDefaults.standard.object(forKey: Constants.annonceAfficheeSession) == nil {
            UserDefaults.standard.set(false, forKey: Constants.annonceAfficheeSession)
        } else {
            UserDefaults.standard.set(false, forKey: Constants.annonceAfficheeSession)
        }
        
        do {
            Network.reachability = try Reachability(hostname: Constants.remoteSite)
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        JSONUnparser.getParameters()

        registerForPushNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let root = self.window?.rootViewController, root.children.count > 0 {
            if root.children[0] is SeanceJourViewController {
                let seanceTab = root.children[0] as! SeanceJourViewController
                if let notification = UserDefaults.standard.string(forKey: Constants.notification), !notification.isEmpty {
                    seanceTab.reloadFromNotification(jour: notification)
                    if let tabBar = seanceTab.tabBarController {
                        tabBar.selectedIndex = 0
                    }
                    //remise à zero
                    UserDefaults.standard.set("", forKey: Constants.notification)
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Notifications.registerDevice(deviceToken: deviceTokenString)
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let custom = userInfo["custom"] as? [String: Any] {
            if let jour = custom["jour"] as? String {
                print("custom jour : \(String(describing: jour))")
                if UserDefaults.standard.object(forKey: Constants.notification) == nil {
                    UserDefaults.standard.set(jour, forKey: Constants.notification)
                } else {
                    UserDefaults.standard.set(jour, forKey: Constants.notification)
                }
            }
        }
    }
}

