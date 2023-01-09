//
//  Cache.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 28/06/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class Cache  {
    
    static let shared = Cache()
    
    private init() {
    }
    
    func defineDictionnary() {
        do {
            if !UserDefaults.standard.isDicoFilmsExists() {
                let dataFilm = try NSKeyedArchiver.archivedData(withRootObject: CacheFilm() as CacheFilm, requiringSecureCoding: false) as NSData
                UserDefaults.standard.setValue(dataFilm, forKey: Constants.cacheFilms)
            }
            
            if !UserDefaults.standard.isDicoParamsExists() {
                let dataFilm = try NSKeyedArchiver.archivedData(withRootObject: CacheParametres() as CacheParametres, requiringSecureCoding: false) as NSData
                UserDefaults.standard.setValue(dataFilm, forKey: Constants.cacheParams)
            }
            
            if !UserDefaults.standard.isDicoSemainesExists() {
                let dataFilm = try NSKeyedArchiver.archivedData(withRootObject: CacheSemaines() as CacheSemaines, requiringSecureCoding: false) as NSData
                UserDefaults.standard.setValue(dataFilm, forKey: Constants.cacheSemaines)
            }
            
            if !UserDefaults.standard.isCacheAlertesExists() {
                let dataFilm = try NSKeyedArchiver.archivedData(withRootObject: CacheAlertes() as CacheAlertes, requiringSecureCoding: false) as NSData
                UserDefaults.standard.setValue(dataFilm, forKey: Constants.cacheAlertes)
            }
        } catch {
            print("couldn't archive")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // MARK: gestion des films
    func loadFilms() -> CacheFilm? {
        do {
            if let unarchivedObject = UserDefaults.standard.object(forKey: Constants.cacheFilms) as? Data {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject) as? CacheFilm
            }
        } catch {
                print("cannot unarchive")
        }
        return nil
    }
    
    func saveFilms(jour: String, filmsToAdd: [Film]) {
        if UserDefaults.standard.isDicoFilmsExists() {
            if let cacheFilm = loadFilms() {
                cacheFilm.mapFilms[jour] = filmsToAdd
                
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: cacheFilm as CacheFilm, requiringSecureCoding: false) as NSData
                    UserDefaults.standard.setValue(data, forKey: Constants.cacheFilms)
                    UserDefaults.standard.synchronize()
                } catch {
                    print("couldn't archive")
                }
            }
        }
    }
    
    // MARK: gestion des paramètres
    func loadParams() -> CacheParametres? {
        do {
            if let unarchivedObject = UserDefaults.standard.object(forKey: Constants.cacheParams) as? Data {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject) as? CacheParametres
            }
        } catch {
                print("cannot unarchive")
        }
        return nil
    }
    
    func saveParams(params: [String]) {
        if UserDefaults.standard.isDicoParamsExists() {
            if let cacheParams = loadParams() {
                cacheParams.params = params
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: cacheParams as CacheParametres, requiringSecureCoding: false) as NSData
                    UserDefaults.standard.setValue(data, forKey: Constants.cacheParams)
                    UserDefaults.standard.synchronize()
                } catch {
                    print("couldn't archive")
                }
            }
        }
    }
    
    // MARK: gestion des semaines
    func loadSemaines() -> CacheSemaines? {
        do {
            if let unarchivedObject = UserDefaults.standard.object(forKey: Constants.cacheSemaines) as? Data {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject) as? CacheSemaines
            }
        } catch {
                print("cannot unarchive")
        }
        return nil
    }
    
    func saveSemaines(semaines: [Semaine]) {
        if UserDefaults.standard.isDicoSemainesExists() {
            if let cacheSemaines = loadSemaines() {
                cacheSemaines.semaines = semaines
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: cacheSemaines as CacheSemaines, requiringSecureCoding: false) as NSData
                    UserDefaults.standard.setValue(data, forKey: Constants.cacheSemaines)
                    UserDefaults.standard.synchronize()
                } catch {
                    print("couldn't archive")
                }
            }
        }
    }
    
    // MARK: gestion des alertes
    func loadAlertes() -> CacheAlertes? {
        do {
            if let unarchivedObject = UserDefaults.standard.object(forKey: Constants.cacheAlertes) as? Data {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject) as? CacheAlertes
            }
        } catch {
            print("cannot unarchive")
        }
        return nil
    }
    
    func saveAlertes(params: [Alertes]) {
        if UserDefaults.standard.isCacheAlertesExists() {
            if let cacheAlertes = loadAlertes() {
                cacheAlertes.alertes = params
                
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: cacheAlertes as CacheAlertes, requiringSecureCoding: false) as NSData
                    UserDefaults.standard.setValue(data, forKey: Constants.cacheAlertes)
                    UserDefaults.standard.synchronize()
                } catch {
                    print("couldn't archive")
                }
            }
        }
    }
}

extension UserDefaults {
    func isDicoFilmsExists() -> Bool {
        if let _ = Cache.shared.loadFilms() {
            return true
        }
        return false
    }
    
    func isDicoParamsExists() -> Bool {
        if let _ = Cache.shared.loadParams() {
            return true
        }
        return false
    }
    
    func isDicoSemainesExists() -> Bool {
        if let _ = Cache.shared.loadSemaines() {
            return true
        }
        return false
    }
    
    func isCacheAlertesExists() -> Bool {
        if let _ = Cache.shared.loadAlertes() {
            return true
        }
        return false
    }
}
