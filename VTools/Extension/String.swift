//
//  String.swift
//  VTools
//
//  Created by Jarvis on 2021/11/25.
//

import Foundation

public extension String {
    /// 截取字符串
    /// - Parameters:
    ///   - start: 开始位数
    ///   - end: 结束位数
    /// - note: "1234" 传入 (0, 2) 得 "12"
    /// "1234" 传入 (1, 2) 得 "2"
    func subRange(_ start: Int, end: Int) -> String {
        let range = Range<Int>.init(uncheckedBounds: (start, end))
        return self.subRange(range)
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - start: 开始位数
    ///   - count: 要截取多少开始之后多少个
    /// - note: "1234" 传入 (0, 1) 得 "1"
    /// "1234" 传入 (1, 3) 得 "234"
    func subRangeCount(_ start: Int, count: Int) -> String {
        let range = Range<Int>.init(uncheckedBounds: (start, start + count))
        return self.subRange(range)
    }
    
    /// 截取字符串
    /// - Parameters:
    ///   - range: 截取范围
    func subRange(_ range: Range<Int>) -> String {
        let sIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let eIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        let str = self[sIndex..<eIndex]
        
        return String(str)
    }
    
    /// 是否为空字符串
    var isBlank: Bool {
        // 扔掉 空格和换行符
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
}
