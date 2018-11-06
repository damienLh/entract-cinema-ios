//
//  AutresDates.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 30/09/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class AutresDates: NSObject, NSCoding {
    
    var date: String
    var horaire: String
    var troisD: Bool
    var vo: Bool
    
    override init() {
        date = ""
        horaire = ""
        troisD = false
        vo = false
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(horaire, forKey: "horaire")
        aCoder.encode(troisD, forKey: "troisD")
        aCoder.encode(vo, forKey: "vo")
    }
    
    required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! String
        horaire = aDecoder.decodeObject(forKey: "horaire") as! String
        troisD = aDecoder.decodeBool(forKey: "troisD")
        vo = aDecoder.decodeBool(forKey: "vo")
    }
}
