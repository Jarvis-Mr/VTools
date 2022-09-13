//
//  UIResultObserverDelegate.swift
//  SmartCampus
//
//  Created by Jarvis on 2022/4/25.
//

import Foundation


public struct UI {
    
    public struct K {
        /// 主页
        public static let homePage = "homePage"
    }
    
    
    struct Notification {
        /// 登录成功
        static let loginSuccess = NSNotification.Name.init(rawValue: "loginSuccess")
        /// 网络切换
        static let networkChanageNotification = NSNotification.Name.init(rawValue: "networkChanage")
        /// 学校切换
        static let schoolChanageNotification = NSNotification.Name.init(rawValue: "schoolChanage")
    }
}


public protocol UIResultObserverDelegate: NSObjectProtocol {
    func loginSuccessResult(_ notification: Notification)
    func networkChanageResult(_ notification: Notification)
    func schoolChanageResult(_ notification: Notification) 
}

extension UIResultObserverDelegate {
    public func loginSuccessResult(_ notification: Notification) {}
    /// 网络切换
    public func networkChanageResult(_ notification: Notification) {}
    /// 学校切换
    public func schoolChanageResult(_ notification: Notification) {}
}
public class UIResultObserver: NSObject {
    public weak var delegate: UIResultObserverDelegate?
    
    public override init() {
        super.init()
    }
    public init(k: String = "", delegate:UIResultObserverDelegate?) {
        super.init()
        self.delegate = delegate
        switch k {
        case UI.K.homePage:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(loginSuccess),
                                                   name: UI.Notification.loginSuccess,
                                                   object: nil)
            break
        default:
            break
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkChanage),
                                               name: UI.Notification.networkChanageNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(schoolChanage),
                                               name: UI.Notification.schoolChanageNotification,
                                               object: nil)
    }
    
    
    @objc func loginSuccess(_ notification: Notification) {
        DispatchQueue.main.async {
            self.delegate?.loginSuccessResult(notification)
        }
    }
    @objc func networkChanage(_ notification: Notification) {
        DispatchQueue.main.async {
            self.delegate?.networkChanageResult(notification)
        }
    }
    
    @objc func schoolChanage(_ notification: Notification) {
        DispatchQueue.main.async {
            self.delegate?.schoolChanageResult(notification)
        }
    }
    
    
    
    
    // MARK: - 网络监听相关操作和属性
    /// 网络状态
    public var networkStatus: Int = 1
    /// 切换之前的网络是否是可用的
    public var isBeforeNetworkReachable: Bool {
        get {
            if networkStatus == -1 || networkStatus == 0 {
                LLog("切换之前的网络是异常的")
                return false
            }
            LLog("切换之前的网络是正常的")
            return true
        }
    }
    /// 网络是否可用
    public static func isReachable(resultCallback: @escaping (Bool)->Void) {
        guard let url = URL(string: "https://baidu.com") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 20.0

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let respone = response as? HTTPURLResponse, respone.statusCode == 200 {
                LLog("当前网络可用")
                resultCallback(true)
            } else {
                LLog("当前网络不可用")
                resultCallback(false)
            }
        }
        dataTask.resume()
    }
    

    
    deinit {
        LLog("销毁监听")
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

extension UIResultObserver {
    public static func postNetworkChanageNotification(status: Int) {
        if status != -1 {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5){
                isReachable { result in
                    NotificationCenter.default.post(name: UI.Notification.networkChanageNotification, object: result ? status : 0)
                }
            }
            
        } else {
            NotificationCenter.default.post(name: UI.Notification.networkChanageNotification, object: status)
        }
    }
    
    public static func postSchoolChanageNotification() {
        NotificationCenter.default.post(name: UI.Notification.schoolChanageNotification, object: nil)
    }
}
