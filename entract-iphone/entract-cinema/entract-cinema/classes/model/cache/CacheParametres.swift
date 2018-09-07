//
//  CacheParametres.swift
//  entract-cinema
//
//  Created by LHEUILLIER Damien (i-BP - INFOTEL) on 06/09/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class CacheParametres: NSObject, NSCoding {
    var params: [String]
    
    override init() {
        params = []
    }
    
    required init(coder aDecoder: NSCoder) {
        params = aDecoder.decodeObject(forKey: Constants.cacheParams) as! [String]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(params, forKey: Constants.cacheParams)
    }
}
