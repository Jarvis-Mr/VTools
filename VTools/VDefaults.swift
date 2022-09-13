//
//  VStoreCache.swift
//  VTools
//
//  Created by Jarvis on 2021/11/26.
//

import Foundation

/**
 数据存储的文件
 */

public struct VDefaults {
    public static var defaults = UserDefaults.standard
    /// 获取 SessionID
    public static func getSession(key: String) -> String? {
        return defaults.string(forKey: key + "lm_session")
    }
    
    /// 存储 SessionID
    public static func setSession(id:String, key: String) {
        defaults.setValue(id, forKey: key + "lm_session")
        defaults.synchronize()
    }
    
    public static func set(value:String, key:String) {
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    public static func get(for key: String) -> String? {
        return defaults.string(forKey: key)
    }
}

@propertyWrapper   /// 先告诉编译器下面这个UserDefault是一个属性包裹器
public struct Defaults<T> {
    public var defaults = UserDefaults.standard
    ///这里的属性key和defaultValue还有init方法都是实际业务中的业务代码
    ///我们不需要过多关注
    let key: String
    let defaultValue: T
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    /// wrappedValue是@propertyWrapper必须要实现的属性
    /// 当操作我们要包裹的属性时其具体setget方法实际上走的都是wrappedValue的setget方法。
    public var wrappedValue: T {
        get {
            return defaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            defaults.set(newValue, forKey: key)
            defaults.synchronize()
        }
    }
}
/*
struct DefaultsConfig {
    /// 告诉编译器我要包裹的是hadShownGuideView这个值。
    /// 实际写法就是在UserDefault包裹器的初始化方法前加了个@
    /// hadShownGuideView属性的一些key和默认值已经在UserDefault包裹器的构造方法中实现
    @Defaults("isBind", defaultValue:false)
    static var bind:Bool
}
*/
