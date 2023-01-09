//
//  Parametre.swift
//  yesvod
//
//  Created by Damien Lheuillier on 18/10/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import Foundation

class Parametre: NSObject, NSCoding {
    var label: String
    var storage: String
    var storageType: String
    var values: [String]
    var valuesType: [Any]
    
    override init() {
        self.label = ""
        self.storage = ""
        self.storageType = ""
        self.values = []
        self.valuesType = []
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(label, forKey: "label")
        aCoder.encode(storage, forKey: "storage")
        aCoder.encode(storageType, forKey: "storageType")
        aCoder.encode(values, forKey: "values")
        aCoder.encode(valuesType, forKey: "valuesType")
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = aDecoder.decodeObject(forKey: "label") != nil ? aDecoder.decodeObject(forKey: "label") as! String : ""
        storage = aDecoder.decodeObject(forKey: "storage") != nil ? aDecoder.decodeObject(forKey: "storage") as! String : ""
        storageType = aDecoder.decodeObject(forKey: "storageType") != nil ? aDecoder.decodeObject(forKey: "storageType") as! String : ""
        values = aDecoder.decodeObject(forKey: "values") != nil ? aDecoder.decodeObject(forKey: "values") as! Array : []
        valuesType = aDecoder.decodeObject(forKey: "valuesType") != nil ? aDecoder.decodeObject(forKey: "valuesType") as! Array : []
    }
}
