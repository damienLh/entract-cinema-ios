//
//  AutresDates.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 30/09/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class AutresDates: NSObject, NSCoding {
    
    var jour: String
    var horaire: String
    var troisD: Bool
    var vo: Bool
    
    override init() {
        jour = ""
        horaire = ""
        troisD = false
        vo = false
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(jour, forKey: "jour")
        aCoder.encode(horaire, forKey: "horaire")
        aCoder.encode(troisD, forKey: "troisD")
        aCoder.encode(vo, forKey: "vo")
    }
    
    required init?(coder aDecoder: NSCoder) {
        jour = aDecoder.decodeObject(forKey: "jour") as! String
        horaire = aDecoder.decodeObject(forKey: "horaire") as! String
        troisD = aDecoder.decodeBool(forKey: "troisD")
        vo = aDecoder.decodeBool(forKey: "vo")
    }
}
