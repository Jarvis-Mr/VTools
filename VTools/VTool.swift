//
//  VTool.swift
//  VTools
//
//  Created by Jarvis on 2021/11/26.
//

import Foundation
import UIKit

public struct VTool {
    /// 主题
    public struct Topic {
       /// 云服务主题
       public static let serverTopic: String = "WifiCommands001"
        /// 设备状态主动上报的主题
        public static func gatewayTopic(hostId: String) -> String {
            return hostId + "mqtt"
        }
       
       /// APP发给WiFi模组设备的消息主题
       public static func appToWifi(mac: String) -> String {
           return "wifi/\(mac)/AppCommands"
       }
       
       /// WiFi模组设备给APP发的消息主题
       public static func wifiToApp(mac: String) -> String {
           return "wifi/\(mac)/DevCommands"
       }
    }
    
    /// APP设置
    public struct App {
        /// 主题色
        @Defaults("mainColor", defaultValue:"#ff9a37")
        public static var mainColor: String
        /// 开启定位权限
        public static func openLocationAuth() {
            guard let openUrl = URL(string: UIApplication.openSettingsURLString) else { return}
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                if UIApplication.shared.canOpenURL(openUrl) {
                    UIApplication.shared.openURL(openUrl)
                }
                
            }
        }
        /// 前往手机设置界面
        public static func openSettings() {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        @available(iOSApplicationExtension, unavailable)
        public static func keyWindow() -> UIWindow? {
            var keyWinwow = UIApplication.shared.keyWindow
            if keyWinwow == nil {
                keyWinwow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            }
            if #available(iOS 13.0, *), keyWinwow == nil {
                keyWinwow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            }
            return keyWinwow
        }
        /// 返回最顶层的 view controller
        @available(iOSApplicationExtension, unavailable)
        public static func topViewController() -> UIViewController? {
            var keyWinwow = UIApplication.shared.keyWindow
            if keyWinwow == nil {
                keyWinwow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            }
            if #available(iOS 13.0, *), keyWinwow == nil {
                keyWinwow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            }
            var top = keyWinwow?.rootViewController
            
            while true {
                if let presented = top?.presentedViewController {
                    top = presented
                } else if let nav = top as? UINavigationController {
                    top = nav.visibleViewController
                } else if let tab = top as? UITabBarController {
                    top = tab.selectedViewController
                } else {
                    break
                }
            }
            
            return top
        }
        /// 返回本地化的app名称
        public static func appName() -> String {
            if let appName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
                return appName
            } else if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
                return appName
            } else {
                return Bundle.main.infoDictionary?["CFBundleName"] as! String
            }
        }
        
        /// 返回版本号
        public static func appVersion() -> String {
            return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        }
        
        public static func buildNumber() -> String {
            return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        }
        
        @Defaults("appId", defaultValue:"v_appid")
        public static var appId: String
        
        @Defaults("testFlightUrl", defaultValue:"v_testFlightUrl")
        public static var testFlightUrl: String
        /// 前往testFlight
        public static func toTestFlight() {
            ///beta.itunes.apple.com/v1/app/1587843066
            var urlString = "beta.itunes.apple.com/v1/app/\(appId)"
            guard let url = URL(string: "itms-beta://") else { return }
            if UIApplication.shared.canOpenURL(url) {
                urlString = "itms-beta://" + urlString
                guard let openUrl = URL(string: urlString) else { return}
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            } else {
                urlString = "https://" + urlString
                guard let openUrl = URL(string: urlString) else { return}
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        public static func toAppStore() {
            let urlString = "https://apps.apple.com/cn/app/\(String(describing: appName))/id\(appId)"
            guard let openUrl = URL(string: urlString) else { return}
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        
        /// 设置显示动画
       public static func startAnimation() {
            let transtition = CATransition()
            transtition.duration = 0.5
            transtition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            keyWindow()?.layer.add(transtition, forKey: "animation")
        }
    }
    
    /// 文件属性
    public struct File {
        /// 连接路径
        public static func join(component: String...) -> String {
            let components = component
            var result: NSString = ""
            for c in components {
                if result.length == 0 {
                    result = c as NSString
                }
                else {
                    result = result.appendingPathComponent(c) as NSString
                }
            }
            
            return result as String
        }
        
        public static var documentsPath: String {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        }
        
        public static var libraryPath: String {
            return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        }
        
        public static var cachesPath: String {
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        }
        
        /// 根据文件大小返回可读的字符串
        public static func formattedSize(size: UInt) -> String {
            let kb = Double(size) / 1000.0
            let mb = Double(size) / 1000.0 / 1000.0
            let gb = Double(size) / 1000.0 / 1000.0 / 1000.0
            
            if gb > 1.0 {
                return String(format: "%.1lfG", gb)
            }
            
            if mb > 1.0 {
                return String(format: "%.1lfM", mb)
            }
            
            if kb > 1.0 {
                return String(format: "%.1lfK", kb)
            }
            
            return "0K"
        }
        
        /// 移动文件
        public static func moveFile(from source: URL, to target: URL) {
            if FileManager.default.fileExists(atPath: source.absoluteString) == false {
                LLog("Souce file does't exist")
                return
            }
            
            if FileManager.default.fileExists(atPath: target.absoluteString) == false {
                LLog("Target file does't exist")
                return
            }
            
            do {
                try FileManager.default.moveItem(at: source, to: target)
            } catch {
                LLog(error)
            }
        }
    }
    
    /// URL 处理
    public struct URI {
        /// 检测合法 URL
        public static func isUrlValid(_ text: String) -> Bool {
            let reg = "((http|https)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
            
            let urlTest = NSPredicate(format: "SELF MATCHES %@", reg)
            
            return urlTest.evaluate(with: text)
        }
        
        /// 检测合法 schemed URL
        public static func isUrlReachable(string urlString: String) -> Bool {
            
            if let url = URL(string: urlString), let _ = url.scheme, let _ = url.host {
                return true
            }
            
            return false
        }

        /// 返回合法的URL
        public static func formatURL(_ string: String, withPrefix prefix: String) -> String {
            
            var urlString = string
            
            let httpRange = string.range(of: "http://")
            let httpsRange = string.range(of: "https://")
            
            if httpRange != nil {
                urlString.removeSubrange(httpRange!)
            } else if httpsRange != nil {
                urlString.removeSubrange(httpsRange!)
            }
            
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
            
            urlString = "\(prefix)\(urlString)"
            
            return urlString
        }
    }
}
