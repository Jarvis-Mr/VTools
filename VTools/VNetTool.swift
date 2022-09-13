//
//  VNetTool.swift
//  VTools
//
//  Created by Jarvis on 2022/5/17.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

public class VNetTool: NSObject {
    
    // MARK: 获取当前设备连接的WiFi
    static func getWiFi() -> [NetworkInfo]? {
        guard let interfaces: NSArray = CNCopySupportedInterfaces() else { return nil }
        var networkInfos = [NetworkInfo]()
        for interface in interfaces {
            let interfaceName = interface as! String
            var networkInfo = NetworkInfo(interface: interfaceName,
                                          success: false,
                                          ssid: nil,
                                          bssid: nil)
            
            if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                networkInfo.success = true
                networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
            }
            networkInfos.append(networkInfo)
        }
        return networkInfos
    }
    
    public static func getWiFiSsid() -> String? {
        guard let wifis = getWiFi() else {
            return nil
        }
        return wifis.first?.ssid
    }
    
    public static func getWifiBSSID() -> String? {
        guard let wifis = getWiFi() else {
            return nil
        }
        return wifis.first?.bssid
    }
    
    
    
    struct NetworkInfo {
        var interface: String
        var success: Bool = false
        var ssid: String?
        var bssid: String?
    }
}
