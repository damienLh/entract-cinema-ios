//
//  Alertes.swift
//  yesvod
//
//  Created by Damien Lheuillier on 09/05/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import Foundation

class Alertes: NSObject, NSCoding {
    
    var jour: String
    var film: Film
    
    override init() {
        jour = ""
        film = Film()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(jour, forKey: "jour")
        aCoder.encode(film, forKey: "film")
    }
    
    required init?(coder aDecoder: NSCoder) {
        jour = aDecoder.decodeObject(forKey: "jour") as! String
        film = aDecoder.decodeObject(forKey: "film") as! Film
    }
}
