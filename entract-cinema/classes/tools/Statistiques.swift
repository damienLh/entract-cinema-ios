//
//  Statistiques.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 09/09/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class Statistiques {
    
    static func statDetailFilm(jour: String!, titreFilm: String!) -> Void {
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            if let myJour = jour, let myFilm = titreFilm {
                let url = "\(server)/php/rest/updateStatistiques.php?page=page_detail&jour=\(myJour)&film=\(myFilm)"
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
