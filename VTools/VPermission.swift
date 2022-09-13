//
//  VPermission.swift
//  VTools
//
//  Created by Jarvis on 2022/4/26.
//

import UIKit
import Photos
import UserNotifications

public typealias AuthClouser = ((Bool)->())

public class VPermission: NSObject {
    
    /// 相机权限
    /// - Parameter clouser: --
    public static func authCamera(clouser: @escaping AuthClouser) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .notDetermined:
            /// 请求权限
            AVCaptureDevice.requestAccess(for: .video) { (result) in
                DispatchQueue.main.async {
                    clouser(result)
                }
            }
        case .authorized:
            clouser(true)
        default:
            clouser(false)
        }
    }
    
    /// 相册权限
    /// - Parameter clouser: --
    public static func authPhotos(clouser: @escaping AuthClouser) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    clouser(status == .authorized)
                }
            }
        case .authorized:
            clouser(true)
        default:
            clouser(false)
        }
    }
    
    /// 通知权限
    /// - Parameter clouser: --
    public static func authNotification(clouser: @escaping AuthClouser){
         if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
                 switch setttings.authorizationStatus {
                 case .notDetermined:
                     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (result, error) in
                         if result{
                             DispatchQueue.main.async {
                                 clouser(true)
                             }
                         }else{
                             DispatchQueue.main.async {
                                 clouser(false)
                             }
                         }
                     }
                 case .authorized, .provisional:
                     clouser(true)
                 default:
                     clouser(false)
                 }
             }
         } else {
             // Fallback on earlier versions
         }
     }
}
