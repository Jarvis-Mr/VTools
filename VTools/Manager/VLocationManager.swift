//
//  VLocationManager.swift
//  VTools
//
//  Created by Jarvis on 2021/12/2.
//

import Foundation
import CoreLocation
public class VLocationManager: NSObject {
    public static var shared = VLocationManager()
    var locationManager: CLLocationManager?
    public var noLocationAuthCallback: ((String) -> Void)?
    public var locationAuthOpenCallback: (() -> Void)?
    override init() {
        super.init()
//        userLocationAuth()
    }
    /// 获取定位权限
    public func userLocationAuth() {
        if getUserLocationAuth() == false {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
            return
        }
        locationAuthOpenCallback?()
    }
    func getUserLocationAuth() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        default :
            return false
        }
    }
    public func monitorLocation(authorCallback:(() -> Void)?, noAuthorCallback:((String) -> Void)?) {
        locationAuthOpenCallback = authorCallback
        noLocationAuthCallback = noAuthorCallback
    }
}

extension VLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var result = false
        switch status {
        case .denied:
            let message = "您需要打开定位权限，才可以获取到 Wi-Fi 信息进行配网。请到设置 -> 隐私 -> 定位服务中开启 [VSC] 定位服务"
            noLocationAuthCallback?(message)
            return
        case .authorizedAlways:
            result = true
        case .authorizedWhenInUse:
            result = true
        default:
            break
        }
        
        if result == true {
            locationAuthOpenCallback?()
        }
        
    }
}
