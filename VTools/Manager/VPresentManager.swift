//
//  VPresentManager.swift
//  SmartCampus
//
//  Created by Jarvis on 2022/5/7.
//

import UIKit

// MARK: -  跳转控制器的model需要实现的协议
public protocol Present: NSObjectProtocol {
    var presentType: String { get }
}
// MARK: -  跳转控制器的VC需要实现的协议
public protocol VCtrProtocol: UIViewController {
    /// 模型
    var model: Present? { get set }
}

public extension VCtrProtocol {
    var model: Present? {
        get { return nil }
        set {}
    }
}

// MARK: - VSelfAware protocol
public protocol VSelfAware: NSObjectProtocol {
    static func vensiAwake()
}
 
public class VPresentManager: NSObject {
    class RegisterModel: NSObject {
        
        var type : String = ""
        /// true 就是用 push 方法
        var push = false
        
        /// false 就是不用动画
        var animated = true
        
        var v_class: VCtrProtocol.Type?
        
    }
    
    @objc public static let shared = VPresentManager()
    private var registerControlModelArr = [RegisterModel]()
    public override init() {
        super.init()
    }
    
    /// 注册设备控制页面跳转
    public func registerControlViewController(_ type: String, v_class: VCtrProtocol.Type?, push: Bool = false) {
        let model = VPresentManager.RegisterModel.init()
        model.type = type
        model.v_class = v_class
        model.push = push
        self.registerControlViewController(model)
        
    }
    
    /// 注册控制页面跳转
    func registerControlViewController(_ model: VPresentManager.RegisterModel) {
        self.registerControlModelArr.append(model)
    }
    
    /// 页面跳转   callback : 不支持的回调
    public func presentControlViewController(_ model: Present, callback:((Bool) ->Void)?) {
       
        var devVC: UIViewController?
        var rModel: RegisterModel?
        for item in self.registerControlModelArr {
            if model.presentType == item.type, let xq_class = item.v_class {
                devVC = xq_class.init()
                rModel = item
                break
            }
        }
        
        if let devVC = devVC, let rModel = rModel {
            (devVC as? VCtrProtocol)?.model = model
            if rModel.push {
                
                if let tbc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, (tbc.viewControllers?.count ?? 0) != 0, let nc = tbc.viewControllers?[tbc.selectedIndex] as? UINavigationController {
                    // tabbar 为基础的
                    nc.pushViewController(devVC, animated: rModel.animated)
                }else if let nc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    // 直接 navigation 为基础的
                    nc.pushViewController(devVC, animated: rModel.animated)
                }
                
            }else {
                UIApplication.shared.keyWindow?.rootViewController?.present(devVC, animated: rModel.animated, completion: nil)
            }
            
        }else {
            print("无法跳转")
            callback?(false)
        }
    }
    
    /// 注册详情页面跳转
    func registerDetailViewController() {
        
    }
    
    /// 模拟+load方法，只调用一次就行
    public func harmlessFunction() {
        print(#function, "harmlessFunction init")
        
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleaseintTypes, Int32(typeCount)) //获取所有的类
        for index in 0 ..< typeCount {
            (types[index] as? VSelfAware.Type)?.vensiAwake() //如果该类实现了SelfAware协议，那么调用awake方法
        }
        types.deallocate()
        
        print(#function, "harmlessFunction done")
        
    }
}
