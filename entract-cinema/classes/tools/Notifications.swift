//
//  Notifications.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 11/09/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class Notifications {
    
    static func registerDevice(deviceToken: String) -> Void {
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            var request = URLRequest(url: URL(string: "\(server)/php/rest/registerPushNotifications?&type=ios&deviceToken=\(deviceToken)")!)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                semaphore.signal()
            })
            task.resume()
        }
    }
}
