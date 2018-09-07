//
//  CacheSemaines.swift
//  entract-cinema
//
//  Created by LHEUILLIER Damien (i-BP - INFOTEL) on 06/09/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class CacheSemaines: NSObject, NSCoding {
    var semaines: [Semaine]
    
    override init() {
        semaines = []
    }
    
    required init(coder aDecoder: NSCoder) {
        semaines = aDecoder.decodeObject(forKey: Constants.cacheSemaines) as! [Semaine]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(semaines, forKey: Constants.cacheSemaines)
    }
}
