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
        if !UserDefaults.standard.isDicoFilmsExists() {
            let dataFilm = NSKeyedArchiver.archivedData(withRootObject: CacheFilm() as CacheFilm) as NSData
            UserDefaults.standard.setValue(dataFilm, forKey: Constants.cacheFilms)
        }
        
        if !UserDefaults.standard.isDicoParamsExists() {
            let dataFilm = NSKeyedArchiver.archivedData(withRootObject: CacheParametres() as CacheParametres) as NSData
            UserDefaults.standard.setValue(dataFilm, forKey: Constants.cacheParams)
        }
        
        if !UserDefaults.standard.isDicoSemainesExists() {
            let dataFilm = NSKeyedArchiver.archivedData(withRootObject: CacheSemaines() as CacheSemaines) as NSData
            UserDefaults.standard.setValue(dataFilm, forKey: Constants.cacheSemaines)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    // MARK: gestion des films
    func loadFilms() -> CacheFilm? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: Constants.cacheFilms) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? CacheFilm
        }
        
        return nil
    }
    
    func saveFilms(jour: String, filmsToAdd: [Film]) {
        if UserDefaults.standard.isDicoFilmsExists() {
            if let cacheFilm = loadFilms() {
                cacheFilm.mapFilms[jour] = filmsToAdd
                let data = NSKeyedArchiver.archivedData(withRootObject: cacheFilm as CacheFilm) as NSData
                UserDefaults.standard.setValue(data, forKey: Constants.cacheFilms)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    // MARK: gestion des paramètres
    func loadParams() -> CacheParametres? {
        if let unarchivedObject = UserDefaults.standard.object(forKey: Constants.cacheParams) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? CacheParametres
        }
        
        return nil
    }
    
    func saveParams(params: [String]) {
        if UserDefaults.standard.isDicoParamsExists() {
            if let cacheParams = loadParams() {
                cacheParams.params = params
                let data = NSKeyedArchiver.archivedData(withRootObject: cacheParams as CacheParametres) as NSData
                UserDefaults.standard.setValue(data, forKey: Constants.cacheParams)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    // MARK: gestion des semaines
    func loadSemaines() -> CacheSemaines? {
        if let unarchivedObject = UserDefaults.standard.object(forKey: Constants.cacheSemaines) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? CacheSemaines
        }
        
        return nil
    }
    
    func saveSemaines(semaines: [Semaine]) {
        if UserDefaults.standard.isDicoSemainesExists() {
            if let cacheSemaines = loadSemaines() {
                cacheSemaines.semaines = semaines
                let data = NSKeyedArchiver.archivedData(withRootObject: cacheSemaines as CacheSemaines) as NSData
                UserDefaults.standard.setValue(data, forKey: Constants.cacheSemaines)
                UserDefaults.standard.synchronize()
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
}
