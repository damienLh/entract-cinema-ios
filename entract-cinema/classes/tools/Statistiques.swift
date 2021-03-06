//
//  Statistiques.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 09/09/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class Statistiques {
    
    static func statDetailFilm(idSeance : String!) -> Void {
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            if let mySeance = idSeance {
                let url = "\(server)/php/rest/updateStatistiques.php?page=page_detail&seance=\(mySeance)"
                let myURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                var request = URLRequest(url: myURL!)
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
    
    static func statCalendrier(idSeance : String!, isRemove: Bool) -> Void {
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            if let mySeance = idSeance {
                var url = "\(server)/php/rest/updateStatistiques.php?page=ajout_cal&seance=\(mySeance)"
                if isRemove {
                    url = "\(server)/php/rest/updateStatistiques.php?page=remove_cal&seance=\(mySeance)"
                }
                
                let myURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                var request = URLRequest(url: myURL!)
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
    
    static func statProgramme() -> Void {
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            var request = URLRequest(url: URL(string: "\(server)/php/rest/updateStatistiques.php?page=page_programme")!)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                semaphore.signal()
            })
            task.resume()
        }
    }
    
    static func statEvenement() -> Void {
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            var request = URLRequest(url: URL(string: "\(server)/php/rest/updateStatistiques.php?page=page_evt")!)
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
