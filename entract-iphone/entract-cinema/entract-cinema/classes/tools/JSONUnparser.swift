//
//  JSONUnparser.swift
//  entract-cinema
//
//  Created by dlheuillier on 27/06/2018
//  Copyright © 2018 Entract. All rights reserved.
//

import Foundation

class JSONUnparser {
    
    static func getFilms(dateJour: String)->[Film] {
        
        let server = Tools.shared.getTargetServer()
        var result: [Film] = []
        
        if Tools.shared.isNetworkOrWifiAvailable() {
            var request = URLRequest(url: URL(string: "\(server)/php/rest/getFilmsJour.php?jour=\(dateJour)")!)
            request.httpMethod = "GET"
            
            let semaphore = DispatchSemaphore(value: 0)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary {
                        let films = json.object(forKey: "films") as! NSArray
                        var listeFilms: [Film] = []
                        let _: NSDictionary
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        
                        for dicoFilm in films {
                            let film: Film = Film()
                            film.titre = (dicoFilm as AnyObject).object(forKey: "titre") as! String
                            let date = dateFormatter.date(from: dateJour)
                            film.date = date!
                            film.horaire = (dicoFilm as AnyObject).object(forKey: "horaire") as! String
                            film.troisD = (dicoFilm as AnyObject).object(forKey: "3d") as! Bool
                            film.vo = (dicoFilm as AnyObject).object(forKey: "vo") as! Bool
                            film.affiche = (dicoFilm as AnyObject).object(forKey: "affiche") as! String
                            film.duree = (dicoFilm as AnyObject).object(forKey: "duree") as! String
                            film.duree = Tools.shared.manageDuree(duree: film.duree)
                            film.annee = (dicoFilm as AnyObject).object(forKey: "annee") as! String
                            film.pays = (dicoFilm as AnyObject).object(forKey: "pays") as! String
                            film.style = (dicoFilm as AnyObject).object(forKey: "style") as! String
                            film.de = (dicoFilm as AnyObject).object(forKey: "de") as! String
                            film.avec = (dicoFilm as AnyObject).object(forKey: "avec") as! String
                            film.synopsis = (dicoFilm as AnyObject).object(forKey: "synopsis") as! String
                            film.bandeAnnonce = (dicoFilm as AnyObject).object(forKey: "bande_annonce") as! String
                            listeFilms.append(film)
                        }
                        result = listeFilms
                    }
                    semaphore.signal()
                }
            })
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        } else {
            if let cacheFilm = Cache.shared.loadFilms() {
                if let films = cacheFilm.mapFilms[dateJour], films.count > 0 {
                    result = films
                }
            }
        }

        Cache.shared.saveFilms(jour: dateJour, filmsToAdd: result)
        return result
    }
    
    static func getAfficheEvenements() -> String {
        var result = ""
        var liens: [String] = []
        let server = Tools.shared.getTargetServer()
        var request = URLRequest(url: URL(string: "\(server)/php/rest/getLiensEvenement.php")!)
        request.httpMethod = "GET"
        
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        
        if Tools.shared.isNetworkOrWifiAvailable() {
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    let app = json?.object(forKey: "liens") as! NSArray?
                    for object in app! {
                        if let lien = object as? String {
                            liens.append(lien)
                        }
                    }
                    semaphore.signal()
                }
            })
            task.resume()
        }
    
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if liens.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(liens.count)))
            result = liens[randomIndex]
        }
        
        return result
    }
    
    static func getParameters() -> Void {
        
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            var request = URLRequest(url: URL(string: "\(server)/php/rest/getParametres.php")!)
            request.httpMethod = "GET"
            
            let semaphore = DispatchSemaphore(value: 0)
            let session = URLSession.shared
            
            if !server.contains("localhost") {
                let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                    do {
                        let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
                        let app = json?.object(forKey: "parametres") as! NSArray?
                        for parametres in app! {
                            let dateMin = (parametres as AnyObject).object(forKey: "date_minimum") as! String
                            let dateMax = (parametres as AnyObject).object(forKey: "date_maximum") as! String
                            
                            UserDefaults.standard.set(dateMin, forKey: Constants.dateMin)
                            UserDefaults.standard.set(dateMax, forKey: Constants.dateMax)
                            
                            let params = [dateMin, dateMax]
                            Cache.shared.saveParams(params: params)
                        }
                        semaphore.signal()
                    }
                })
                task.resume()
            }
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        } else {
            if let cacheParams = Cache.shared.loadParams(), cacheParams.params.count == 2 {
                UserDefaults.standard.set(cacheParams.params[0], forKey: Constants.dateMin)
                UserDefaults.standard.set(cacheParams.params[1], forKey: Constants.dateMax)
            }
        }
    }
    
    static func getProgramme()->[Semaine] {
        var result: [Semaine] = []
        
        if Tools.shared.isNetworkOrWifiAvailable() {
            let server = Tools.shared.getTargetServer()
            var request = URLRequest(url: URL(string: "\(server)/php/rest/getProgramme.php")!)
            request.httpMethod = "GET"
            
            let semaphore = DispatchSemaphore(value: 0)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
                    let app = json?.object(forKey: "semaine") as! NSArray?
                    let _ : NSDictionary
                    for dict in app! {
                        let semaine: Semaine = Semaine()
                        semaine.debutsemaine = (dict as AnyObject).object(forKey: "debutsemaine") as! String
                        semaine.finsemaine = (dict as AnyObject).object(forKey: "finsemaine") as! String
                        let jours = (dict as AnyObject).object(forKey: "jours") as! NSArray
                        var listeJours: [Jours] = []
                        let _: NSDictionary
                        for dicoJours in jours {
                            let jour = Jours()
                            jour.jour = (dicoJours as AnyObject).object(forKey: "jour") as! String
                            let films = (dicoJours as AnyObject).object(forKey: "films") as! NSArray
                            var listeFilms: [Film] = []
                            let _: NSDictionary
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            
                            for dicoFilm in films {
                                let film: Film = Film()
                                
                                film.titre = (dicoFilm as AnyObject).object(forKey: "titre") as! String
                                let dateJour = (dicoFilm as AnyObject).object(forKey: "date") as! String
                                let date = dateFormatter.date(from: dateJour)
                                film.date = date!
                                film.horaire = (dicoFilm as AnyObject).object(forKey: "horaire") as! String
                                film.troisD = (dicoFilm as AnyObject).object(forKey: "3d") as! Bool
                                film.vo = (dicoFilm as AnyObject).object(forKey: "vo") as! Bool
                                listeFilms.append(film)
                            }
                            jour.films = listeFilms
                            listeJours.append(jour)
                        }
                        semaine.jours = listeJours
                        result.append(semaine)
                    }
                    semaphore.signal()
                }
            })
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        } else {
            if let cacheSemaines = Cache.shared.loadSemaines() {
                if cacheSemaines.semaines.count > 0 {
                    result = cacheSemaines.semaines
                }
            }
        }
        
        Cache.shared.saveSemaines(semaines: result)
        return result
    }
}
