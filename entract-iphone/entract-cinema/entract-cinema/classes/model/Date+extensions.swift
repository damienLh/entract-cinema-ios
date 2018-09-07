//
//  Date+extensions.swift
//  SidebarMenu
//
//  Created by Damien Lheuillier on 26/05/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    var toString: String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy"
        return dateFormatterPrint.string(from: self)
    }
}
