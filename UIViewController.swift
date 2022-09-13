//
//  UIViewController.swift
//  VTools
//
//  Created by Jarvis on 2021/11/25.
//

import UIKit

public extension UIViewController {
    
    func topController() -> UIViewController? {
        return UIViewController.topViewController(withRootViewController: self)
    }
    
    var isBeingDismiss: Bool {
        if self.isBeingDismissed || self.tabBarController?.isBeingDismissed == true || self.navigationController?.isBeingDismissed == true {
            return true
        }
        return false
    }
    
    fileprivate class func topViewController(withRootViewController rootViewController: UIViewController?) -> UIViewController? {
        
        guard let root = rootViewController else {
            return nil
        }
        
        if let tabbarController = rootViewController as? UITabBarController {
            return self.topViewController(withRootViewController: tabbarController.selectedViewController)
        }
        
        if let nav = rootViewController as? UINavigationController {
            return self.topViewController(withRootViewController: nav.visibleViewController)
        }
        
        if let presentedViewController = root.presentedViewController {
            return self.topViewController(withRootViewController: presentedViewController)
        }
        
        return root
    }
    
    func toLandscape(_ rightOrientation: Bool) {
        UIDevice.current.setValue(UIDeviceOrientation.unknown.rawValue, forKey: "orientation")
        let orientation: UIDeviceOrientation = rightOrientation ? .landscapeRight : .landscapeLeft
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }
    
    func toPortrait() {
        UIDevice.current.setValue(UIDeviceOrientation.unknown.rawValue, forKey: "orientation")
        UIDevice.current.setValue(UIDeviceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
}
