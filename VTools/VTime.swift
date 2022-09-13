//
//  VTimeTool.swift
//  VTools
//
//  Created by Jarvis on 2021/11/24.
//

import Foundation

public struct VTime {
    /// 当前时间戳 (毫秒)
    public static func timeStamp() -> String {
        return String(describing: "\(Int(Date.init().timeIntervalSince1970 * 1000))")
    }
}

extension String {
    public func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
    
    public func toDate2() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: self)
    }
    public func toDate3() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
    /// yyyy-MM-dd to MM月dd日
    public func formatDate() -> String {
        guard let date = toDate() else {return ""}
        let df = DateFormatter()
        df.dateFormat = "MM月dd日"
        return df.string(from: date)
    }
    
    /// 当前时间 "04-01"  yyyy-MM-dd HH:mm:ss  to MM月dd日
    public func formatDate3() -> String {
        guard let date = toDate3() else {return ""}
        let df = DateFormatter()
        df.dateFormat = "MM月dd日"
        return df.string(from: date)
    }
    
    ///yyyy-MM-dd HH:mm:ss  to  MM月dd日 HH:mm
    public func formatDate1() -> String {
        guard let date = toDate3() else {return ""}
        let df = DateFormatter()
        df.dateFormat = "MM月dd日 HH:mm"
        return df.string(from: date)
    }
    ///yyyy-MM-dd HH:mm:ss  to 09:30:25
    public func formatDate2() -> String {
        guard let date = toDate3() else {return ""}
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        return df.string(from: date)
    }
    
    public func formatDateDescribe() -> String {
        guard let date = toDate() else {return ""}
        if NSCalendar.current.isDateInToday(date) {
            return "今天"
        }
        
        if NSCalendar.current.isDateInYesterday(date) {
            return "昨天"
        }
        return self
    }
    
    
}

extension Date {
    /// 当前时间戳
    public static func timestamp() -> String {
        let timeInter = Int(Date().timeIntervalSince1970)
        return "\(timeInter)"
    }
    
    /// 当前时间 "2020-04-01"
    public static func format1() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }
    /// 当前时间 "04-01"
    public static func format2() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "MM/dd"
        return df.string(from: date)
    }
    
    /// 当前时间 "2020-04-01 08:30"
    public func format3() -> String {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        return df.string(from: self)
    }
    
    /// 当前时间 "2020-04-01"
    public func format4() -> String {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self)
    }
    
    /// 当前时间 "08:30"
    public func format5() -> String {

        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: self)
    }
    
    /// 当前时间 "08:30"
    public func format6() -> String {

        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        return df.string(from: self)
    }
    /// 日
    public func day() -> Int {
        return NSCalendar.current.component(.day, from: self)
    }
    /// 月
    public func month() -> Int {
        return NSCalendar.current.component(.month, from: self)
    }
    /// 年
    public func year() -> Int {
        return NSCalendar.current.component(.year, from: self)
    }
    
    /// 时
    public func hour() -> Int {
        return NSCalendar.current.component(.hour, from: self)
    }
    /// 分
    public func minute() -> Int {
        return NSCalendar.current.component(.minute, from: self)
    }
    
    /// 秒
    public func second() -> Int {
        return NSCalendar.current.component(.second, from: self)
    }
    /// 周天
    public func weekday() -> Int {
        return NSCalendar.current.component(.weekday, from: self)
    }
    
    /// 小时合集
    public static func hours() -> [String] {
        var s: [String] = []
        for item in 0..<24 {
            s.append(String(format: "%02ld", item))
        }
        return s
    }
    /// 分钟合集
    public static func minutes() -> [String] {
        var s: [String] = []
        for item in 0..<60 {
            s.append(String(format: "%02ld", item))
        }
        return s
    }
    
    /// 年份合集
    public static func years(for date: Date) -> [String] {
        let year = date.year()
        var s: [String] = []
        for item in -100..<100 {
            s.append(String(format: "%ld", year + item))
        }
        return s
    }
    
    /// 月份合集
    public static func months() -> [String] {
        var s: [String] = []
        for item in 0..<12 {
            s.append(String(format: "%02ld", item + 1))
        }
        return s
    }
    
    /// 判断是否是闰年(返回的的值,总天数)
    public static func leapYearCompare(year: Int, month: Int) -> Int {
        let normalYear = [31,28,31,30,31,30,31,31,30,31,30,31]
        let leapYear = [31,29,31,30,31,30,31,31,30,31,30,31]
        if year%4 == 0 && year%100 != 0 || year % 400 == 0 {
            return leapYear[month - 1]
        } else {
            return normalYear[month - 1]
        }
    }
    
    /// 天数合集
    public static func days(total: Int) -> [String] {
        var s: [String] = []
        for item in 0..<total {
            s.append(String(format: "%02ld", item + 1))
        }
        return s
    }
    
    public func timeFormat() -> String {
        if NSCalendar.current.isDateInToday(self) {
            return String(format: "今天 %02ld:%02ld", self.hour(),self.minute())
        }
        
        if NSCalendar.current.isDateInYesterday(self) {
            return String(format: "昨天 %02ld:%02ld", self.hour(),self.minute())
        }
        
        let df = DateFormatter()
        df.dateFormat = "MM月dd日 HH:mm"
        return df.string(from: self)
    }
    
}


var blockKey = "blockKey"

extension Timer {
    static var block: (Timer) -> Void {
        get {
            return objc_getAssociatedObject(self, &blockKey) as! (Timer) -> Void
        }
        set {
            objc_setAssociatedObject(self, &blockKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }

    public static func vscheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        if #available(iOS 10.0, *) {
            return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
        } else {
            // Fallback on earlier versions
            self.block = block
            return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(runTimer), userInfo: nil, repeats: repeats)
        }
    }
    
    @objc public static func runTimer(timer: Timer) {
        block(timer)
    }
}

//public class VTimer: Timer {
//    var block: (Timer) -> Void
//
//    public func vscheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: escaping (Timer) -> Void) -> Timer {
//        if #available(iOS 10.0, *) {
//            return Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
//        } else {
//            // Fallback on earlier versions
//            return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(runTimer), userInfo: nil, repeats: repeats)
//        }
//    }
//
//    objc public func runTimer() {
//
//    }
//
//
//}
