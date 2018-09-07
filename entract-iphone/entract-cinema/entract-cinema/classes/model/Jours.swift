//
//  Jours.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 09/06/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class Jours: NSObject, NSCoding {
    var jour: String
    var films: [Film]
    
    
    override init() {
        jour = ""
        films = [Film]()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(jour, forKey: "jour")
        aCoder.encode(films, forKey: "films")
    }
    
    required init?(coder aDecoder: NSCoder) {
        jour = aDecoder.decodeObject(forKey: "jour") as! String
        films = aDecoder.decodeObject(forKey: "films") as! [Film]
    }
}
