//
//  VLog.swift
//  VTools
//
//  Created by Jarvis on 2021/11/24.
//

import Foundation

public func LLog(_ items: Any...,
    file: String = #file,
    method: String = #function,
    line: Int = #line)
{
    #if DEBUG
    var output = ""
    for item in items {
        output += "\(item) "
    }
    output += "\n"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = dateFormatter.string(from: Date())
    print("\(timestamp) | \((file as NSString).lastPathComponent)[\(line)] > \(method): ")
    print(output)
    #endif
}
