//
//  CacheAlertes.swift
//  yesvod
//
//  Created by Damien Lheuillier on 09/05/2020.
//  Copyright © 2020 Antonin Fankrache. All rights reserved.
//

import Foundation

class CacheAlertes: NSObject, NSCoding {
    var alertes: [Alertes]
    
    override init() {
        alertes = []
    }
    
    required init(coder aDecoder: NSCoder) {
        alertes = aDecoder.decodeObject(forKey: Constants.cacheAlertes) as! [Alertes]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(alertes, forKey: Constants.cacheAlertes)
    }
}
