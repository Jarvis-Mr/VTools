//
//  VDeviceTool.swift
//  VTools
//
//  Created by Jarvis on 2021/11/24.
//

import Foundation

public struct VDevice {
    
    static let pixelOne: CGFloat = {
        return 1 / UIScreen.main.scale
    }()
    
    static let isSimulator: Bool = {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }()
    
    static let isIPad: Bool = {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }()
    
    @available(iOSApplicationExtension, unavailable)
    static let isZoomedMode: Bool = {
        if isIPad {
            return false
        }
        let nativeScale = UIScreen.main.nativeScale
        var scale = UIScreen.main.scale
        
        let shouldBeDownsampledDevice = UIScreen.main.nativeBounds.size.equalTo(CGSize(width: 1080, height: 1920))
        if shouldBeDownsampledDevice {
            scale /= 1.15;
        }
        return nativeScale > scale
    }()
    
    @available(iOSApplicationExtension, unavailable)
    static let isRegularScreen: Bool = {
        return isIPad || (!isZoomedMode && (is61InchScreen || is61InchScreen || is55InchScreen))
    }()
    
    /// 是否横竖屏，用户界面横屏了才会返回true
    @available(iOSApplicationExtension, unavailable)
    static var isLandscape: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    /// 屏幕宽度，跟横竖屏无关
    @available(iOSApplicationExtension, unavailable)
    static let deviceWidth = isLandscape ? UIScreen.main.bounds.height : UIScreen.main.bounds.width

    /// 屏幕高度，跟横竖屏无关
    @available(iOSApplicationExtension, unavailable)
    static let deviceHeight = isLandscape ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
    
    /// tabbar  高度
    @available(iOSApplicationExtension, unavailable)
    static var tabBarHeight: CGFloat {
        if isIPad {
            if hasBottomSafeAreaInsets {
                return 65
            } else {
                if #available(iOS 12.0, *) {
                    return 50
                } else {
                    return 49
                }
            }
        } else {
            let height: CGFloat
            if isLandscape, !isRegularScreen {
                height = 32
            } else {
                height = 49
            }
            return height + safeAreaInsets.bottom
        }
    }
    
    public static var bottomHeight: CGFloat {
        get {
            return hasTopNotch ? 34.0 : 0.0
        }
    }
    
    public static func DeviceOS() -> String {
        return UIDevice.current.name
//        return getDeviceVersion().rawValue
    }
    
    /// 获取状态栏高度
    public static func statusHeight() -> CGFloat {
        var height: CGFloat = 0
        if #available(iOS 13.0, *) {
            guard let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return -1
            }
            height = ws.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        if height >= 30 {
            return height
        }
        return 20
    }
    
    /// 获取导航栏高度
    public static func navigationHeight() -> CGFloat {
        return statusHeight() + 44
    }
    
    /// 获取Tabbar高度
    public static func tabbarHeight() -> CGFloat {
        return statusHeight() >= 30 ? 83 : 49
    }
    
    /// 是否有刘海
    @available(iOSApplicationExtension, unavailable)
    public static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with notch: 44.0 on iPhone X, XS, XS Max, XR.
            // without notch: 20.0 on iPhone 8 on iOS 12+.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    /// 是否有底部Home区域
    @available(iOSApplicationExtension, unavailable)
    public static var hasBottomSafeAreaInsets: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with home indicator: 34.0 on iPhone X, XS, XS Max, XR.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        }
        
        return false
    }
    
    /// 安全区
    @available(iOSApplicationExtension, unavailable)
    public static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, tvOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
                return safeAreaInsets
            } else if let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets {
                return safeAreaInsets
            }
        }
    
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
}

@available(iOSApplicationExtension, unavailable)
extension VDevice {
    static let is65InchScreen: Bool = {
        if CGSize(width: deviceWidth, height: deviceHeight) != screenSizeFor65Inch {
            return false
        }
        let deviceModel = VDevice.deviceModel()
        if deviceModel != "iPhone11,4" && deviceModel == "iPhone11,6" && deviceModel != "iPhone12,5" {
            return false
        }
        return true
    }()
    
    static let is61InchScreen: Bool = {
        if CGSize(width: deviceWidth, height: deviceHeight) != screenSizeFor61Inch {
            return false
        }
        let deviceModel = VDevice.deviceModel()
        if deviceModel != "iPhone11,8" && deviceModel == "iPhone12,1" {
            return false
        }
        return true
    }()
    
    static let is58InchScreen: Bool = {
        return CGSize(width: deviceWidth, height: deviceHeight) == screenSizeFor58Inch
    }()
    
    static let is55InchScreen: Bool = {
        return CGSize(width: deviceWidth, height: deviceHeight) == screenSizeFor55Inch
    }()
    
    static let is47InchScreen: Bool = {
        return CGSize(width: deviceWidth, height: deviceHeight) == screenSizeFor47Inch
    }()
    
    static let is40InchScreen: Bool = {
        return CGSize(width: deviceWidth, height: deviceHeight) == screenSizeFor40Inch
    }()
    
    static var is35InchScreen: Bool {
        return CGSize(width: deviceWidth, height: deviceHeight) == screenSizeFor35Inch
    }
    
    static var screenSizeFor65Inch: CGSize {
        return CGSize(width: 414, height: 896)
    }
    
    static var screenSizeFor61Inch: CGSize {
        return CGSize(width: 414, height: 896)
    }

    static var screenSizeFor58Inch: CGSize {
        return CGSize(width: 375, height: 812)
    }

    static var screenSizeFor55Inch: CGSize {
        return CGSize(width: 414, height: 736)
    }

    static var screenSizeFor47Inch: CGSize {
        return CGSize(width: 375, height: 667)
    }
    
    static var screenSizeFor40Inch: CGSize {
        return CGSize(width: 320, height: 568)
    }

    static var screenSizeFor35Inch: CGSize {
        return CGSize(width: 320, height: 480)
    }

}


extension VDevice {
    /// 原始设备型号
    static func deviceModel() -> String {
        if VDevice.isSimulator {
            return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"
        }
        var systemInfo = utsname()
        uname(&systemInfo)
        
        if let utf8String = NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)?.utf8String {
            if let versionCode = String(validatingUTF8: utf8String) {
                return versionCode
            }
        }
        
        return "unknown"
    }
    
    /// 返回精确设备型号
    static func getDeviceVersion() -> Version {
        let deviceModel = VDevice.deviceModel()
        
        
        switch deviceModel {
            /*** iPhone ***/
            case "iPhone1,1":                                return .iPhone2G
            case "iPhone1,2":                                return .iPhone3G
            case "iPhone2,1":                                return .iPhone3GS
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return .iPhone4
            case "iPhone4,1", "iPhone4,2", "iPhone4,3":      return .iPhone4S
            case "iPhone5,1", "iPhone5,2":                   return .iPhone5
            case "iPhone5,3", "iPhone5,4":                   return .iPhone5C
            case "iPhone6,1", "iPhone6,2":                   return .iPhone5S
            case "iPhone7,2":                                return .iPhone6
            case "iPhone7,1":                                return .iPhone6Plus
            case "iPhone8,1":                                return .iPhone6S
            case "iPhone8,2":                                return .iPhone6SPlus
            case "iPhone8,3", "iPhone8,4":                   return .iPhoneSE
            case "iPhone9,1", "iPhone9,3":                   return .iPhone7
            case "iPhone9,2", "iPhone9,4":                   return .iPhone7Plus
            case "iPhone10,1", "iPhone10,4":                 return .iPhone8
            case "iPhone10,2", "iPhone10,5":                 return .iPhone8Plus
            case "iPhone10,3", "iPhone10,6":                 return .iPhoneX
            case "iPhone11,2":                               return .iPhoneXS
            case "iPhone11,4", "iPhone11,6":                 return .iPhoneXS_Max
            case "iPhone11,8":                               return .iPhoneXR
            case "iPhone12,1":                               return .iPhone11
            case "iPhone12,3":                               return .iPhone11Pro
            case "iPhone12,5":                               return .iPhone11Pro_Max
            case "iPhone12,8":                               return .iPhoneSE2
            case "iPhone13,1":                               return .iPhone12Mini
            case "iPhone13,2":                               return .iPhone12
            case "iPhone13,3":                               return .iPhone12Pro
            case "iPhone13,4":                               return .iPhone12Pro_Max

            /*** iPad ***/
            case "iPad1,1", "iPad1,2":                       return .iPad1
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .iPad2
            case "iPad3,1", "iPad3,2", "iPad3,3":            return .iPad3
            case "iPad3,4", "iPad3,5", "iPad3,6":            return .iPad4
            case "iPad6,11", "iPad6,12":                     return .iPad5
            case "iPad7,5", "iPad7,6":                       return .iPad6
            case "iPad7,11", "iPad7,12":                     return .iPad7
            case "iPad11,6", "iPad11,7":                     return .iPad8
            case "iPad4,1", "iPad4,2", "iPad4,3":            return .iPadAir
            case "iPad5,3", "iPad5,4":                       return .iPadAir2
            case "iPad11,3", "iPad11,4":                     return .iPadAir3
            case "iPad13,1", "iPad13,2":                     return .iPadAir4
            case "iPad2,5", "iPad2,6", "iPad2,7":            return .iPadMini
            case "iPad4,4", "iPad4,5", "iPad4,6":            return .iPadMini2
            case "iPad4,7", "iPad4,8", "iPad4,9":            return .iPadMini3
            case "iPad5,1", "iPad5,2":                       return .iPadMini4
            case "iPad11,1", "iPad11,2":                     return .iPadMini5

            /*** iPadPro ***/
            case "iPad6,3", "iPad6,4":                       return .iPadPro9_7Inch
            case "iPad6,7", "iPad6,8":                       return .iPadPro12_9Inch
            case "iPad7,1", "iPad7,2":                       return .iPadPro12_9Inch2
            case "iPad7,3", "iPad7,4":                       return .iPadPro10_5Inch
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return .iPadPro11_0Inch
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return .iPadPro12_9Inch3
            case "iPad8,9", "iPad8,10":                      return .iPadPro11_0Inch2
            case "iPad8,11", "iPad8,12":                     return .iPadPro12_9Inch4

            /*** iPod ***/
            case "iPod1,1":                                  return .iPodTouch1Gen
            case "iPod2,1":                                  return .iPodTouch2Gen
            case "iPod3,1":                                  return .iPodTouch3Gen
            case "iPod4,1":                                  return .iPodTouch4Gen
            case "iPod5,1":                                  return .iPodTouch5Gen
            case "iPod7,1":                                  return .iPodTouch6Gen
            case "iPod9,1":                                  return .iPodTouch7Gen

            /*** Simulator ***/
            case "i386", "x86_64":                           return .simulator

            default:                                         return .unknown
        }
    
    }
    static fileprivate func getType(code: String) -> Type {
            let versionCode = deviceModel()
            
            if versionCode.contains("iPhone") {
                return .iPhone
            } else if versionCode.contains("iPad") {
                return .iPad
            } else if versionCode.contains("iPod") {
                return .iPod
            } else if versionCode == "i386" || versionCode == "x86_64" {
                return .simulator
            } else {
                return .unknown
            }
        }
    static public func size() -> Size {
            let w: Double = Double(UIScreen.main.bounds.width)
            let h: Double = Double(UIScreen.main.bounds.height)
            let screenHeight: Double = max(w, h)
            
            switch screenHeight {
                case 240, 480:
                    return .screen3_5Inch
                case 568:
                    return .screen4Inch
                case 667:
                    return UIScreen.main.scale == 3.0 ? .screen5_5Inch : .screen4_7Inch
                case 736:
                    return .screen5_5Inch
                case 812:
                    switch getDeviceVersion() {
                    case .iPhone12Mini:
                        return .screen5_4Inch
                    default:
                        return .screen5_8Inch
                    }
                case 844:
                    return .screen6_1Inch
                case 896:
                    switch getDeviceVersion() {
                    case .iPhoneXS_Max, .iPhone11Pro_Max:
                        return .screen6_5Inch
                    default:
                        return .screen6_1Inch
                    }
                case 926:
                    return .screen6_7Inch
                case 1024:
                    switch getDeviceVersion() {
                    case .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5:
                        return .screen7_9Inch
                    case .iPadPro10_5Inch:
                        return .screen10_5Inch
                    default:
                        return .screen9_7Inch
                    }
                case 1080:
                    return .screen10_2Inch
                case 1112:
                    return .screen10_5Inch
                case 1180:
                    return .screen10_9Inch
                case 1194:
                    return .screen11Inch
                case 1366:
                    return .screen12_9Inch
                default:
                    return .unknownSize
            }
        }
        
        static public func type() -> Type {
            return getType(code: deviceModel())
        }

        @available(*, deprecated, message: "use == operator instead")
        static public func isEqualToScreenSize(_ size: Size) -> Bool {
            return size == self.size() ? true : false;
        }

        @available(*, deprecated, message: "use > operator instead")
        static public func isLargerThanScreenSize(_ size: Size) -> Bool {
            return size.rawValue < self.size().rawValue ? true : false;
        }

        @available(*, deprecated, message: "use < operator instead")
        static public func isSmallerThanScreenSize(_ size: Size) -> Bool {
            return size.rawValue > self.size().rawValue ? true : false;
        }
        
        static public func isRetina() -> Bool {
            return UIScreen.main.scale > 1.0
        }

        static public func isPad() -> Bool {
            return type() == .iPad
        }
        
        static public func isPhone() -> Bool {
            return type() == .iPhone
        }
        
        static public func isPod() -> Bool {
            return type() == .iPod
        }
        
//        static public func isSimulator() -> Bool {
//            return type() == .simulator
//        }
}
