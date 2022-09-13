//
//  PlistFile.swift
//  Alamofire
//
//  Created by Jarvis on 2022/4/24.
//

import Foundation


struct File {
    
    static var documentsPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    static var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }
    
    static var cachesPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }
    
    static let App: String = "/App"
}

public protocol VPlistFileProtocol: NSObjectProtocol {
    /// 表名
    static var table: String {get}
    /// 初始数据
    static func initData()
    /// 创建表
    static func createTable()
        
    /// 获取数据
    static func getObjects() -> AnyObject?
    
    /// 更新数据
    /// - Parameters:
    ///   - objects: 数据
    static func update(with objects: AnyObject)
    
}

public extension VPlistFileProtocol {
    
    static var documentsPath: String {
        get {
            return File.documentsPath + File.App
        }
    }
    
    static func createTable() {
        
        if FileManager.default.fileExists(atPath: self.documentsPath) == false {
            do {
                try FileManager.default.createDirectory(atPath: self.documentsPath, withIntermediateDirectories: true, attributes: nil)
                print("plist创建文件夹")
            } catch _ {
                
            }
        }
        let path = self.documentsPath + self.table
        
        if FileManager.default.fileExists(atPath: path) == false {
            if FileManager.default.createFile(atPath: path, contents: nil, attributes: nil) {
                print("创建plist 文件")
            }
        }
        initData()
        print(path)
    }

    /// 获取所有数据
    static func getObjects() -> AnyObject? {
        guard let json = readPlist() else {
            return nil
        }
        return json["data"] as AnyObject
    }
   
    static func update(with objects: AnyObject) {
        let path = self.documentsPath + self.table
        let json = NSMutableDictionary(dictionary: ["data": objects])
        if json.write(toFile: path, atomically: true) {
            print("写入成功")
        } else {
            print("写入失败")
        }
    }
    
    static func readPlist() -> NSDictionary? {
        
        let path = self.documentsPath + self.table
        
        if NSDictionary(contentsOfFile: path) == nil { /// 默认配置
            return NSDictionary()
        }
        
        return NSDictionary(contentsOfFile: path)
    }
}

class PlistFile: NSObject {
    
    override init() {
        super.init()
        
    }
    
}
