//
//  Semaine.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 08/06/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class Semaine: NSObject, NSCoding {

    var debutsemaine: String
    var finsemaine: String
    var jours: [Jours]
    
    override init() {
        debutsemaine = ""
        finsemaine = ""
        jours = [Jours]()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(debutsemaine, forKey: "debutsemaine")
        aCoder.encode(finsemaine, forKey: "finsemaine")
        aCoder.encode(jours, forKey: "jours")
    }
    
    required init?(coder aDecoder: NSCoder) {
        debutsemaine = aDecoder.decodeObject(forKey: "debutsemaine") as! String
        finsemaine = aDecoder.decodeObject(forKey: "finsemaine") as! String
        jours = aDecoder.decodeObject(forKey: "jours") as! [Jours]
    }
}
