//
//  String+Extensions.swift
//  entract-cinema
//
//  Created by dlheuillier on 27/06/2018
//  Copyright © 2018 Entract. All rights reserved.
//

import Foundation

extension String {
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
    
    func convertDateToDayMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat =  "d MMMM"
        dateFormatter2.locale = Locale(identifier: "fr")
        return dateFormatter2.string(from: date!)
    }
    
    func convertDateToLocaleDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat =  "EEEE d MMMM"
        dateFormatter2.locale = Locale(identifier: "fr")
        return dateFormatter2.string(from: date!)
    }
    
    func convertToDbData() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        let date = dateFormatter.date(from: self)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat =  "yyyy-MM-dd"
        return dateFormatter2.string(from: date!)
    }
    
    func convertFromDbDataString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat =  "dd/MM"
        dateFormatter2.locale = Locale(identifier: "fr")
        return dateFormatter2.string(from: date!)
    }
    
    func convertFromDbData() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        return dateFormatter.date(from: self)!
    }
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
