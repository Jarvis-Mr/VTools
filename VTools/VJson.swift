//
//  VJson.swift
//  VTools
//
//  Created by Jarvis on 2021/11/24.
//

import Foundation

extension String {
    /// json字符串转 NSDictionary
    public func toJson() -> NSDictionary? {
        guard let data = self.data(using: .utf8) else {return nil}
        do {
            let dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return dic as? NSDictionary
        } catch _ {
            
        }
        return nil
    }
}

public struct VJson {
    public static func getDatas(_ dataDic: Dictionary<AnyHashable, Any>) -> Array<Dictionary<String, Any>>? {
        let body = dataDic["body"] as? Dictionary<String, Any>
        let datas = body?["datas"] as? Array<Dictionary<String, Any>>
        return datas
    }

    public static func getDatasFirst(_ dataDic: Dictionary<AnyHashable, Any>) -> Dictionary<String, Any>? {
        return getDatas(dataDic)?.first
    }

    public static func getConfig(_ dataDic: Dictionary<AnyHashable, Any>) -> Any? {
        return getDatasFirst(dataDic)?["config"]
    }

    public static func getConfigFirst(_ dataDic: Dictionary<AnyHashable, Any>) -> Dictionary<String, Any>? {
        let config = getConfig(dataDic) as? Array<Dictionary<String, Any>>
        return config?.first
    }
    
    public static func getAttributes(_ dataDic: Dictionary<AnyHashable, Any>) -> Dictionary<String, Any>? {
        let body = dataDic["body"] as? Dictionary<String, Any>
        let datas = body?["attributes"] as? Array<Dictionary<String, Any>>
        return datas?.first
    }
    
    public static func getErrCode(_ dataDic: Dictionary<AnyHashable, Any>) -> Any? {
        let status = getAttributes(dataDic)?["status"] as? Dictionary<String, Any>
        return status?["errcode"]
    }
}
