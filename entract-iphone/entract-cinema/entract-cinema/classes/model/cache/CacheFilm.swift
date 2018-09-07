//
//  CacheFilm.swift
//  entract-cinema
//
//  Created by Damien Lheuillier on 28/06/2018.
//  Copyright © 2018 Damien Lheuillier. All rights reserved.
//

import Foundation

class CacheFilm: NSObject, NSCoding {
    var mapFilms: [String: [Film]]
    
    override init() {
        mapFilms = [:]
    }
    
    required init(coder aDecoder: NSCoder) {
        mapFilms = aDecoder.decodeObject(forKey: Constants.cacheFilms) as! [String: [Film]]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(mapFilms, forKey: Constants.cacheFilms)
    }
}
