//
//  Calendar.swift
//  VTools
//
//  Created by Jarvis on 2022/5/31.
//

import UIKit

public extension NSCalendar {
   static let gregorian: NSCalendar = {
        return NSCalendar.init(calendarIdentifier: .gregorian)!
    }()
    
    
    static func first(week date: Date) ->String {
        return gregorian.firstDay(ofWeek: Date())!.format4()
    }
    
    static func last(week date: Date) ->String {
        return gregorian.lastDay(ofWeek: Date())!.format4()
    }
    
    static func first(month date: Date) ->String {
        return gregorian.firstDay(ofMonth: Date())!.format4()
    }
    
    static func last(month date: Date) ->String {
        return gregorian.lastDay(ofMonth: Date())!.format4()
    }
}
