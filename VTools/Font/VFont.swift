//
//  VFont.swift
//  VTools
//
//  Created by Jarvis on 2022/4/28.
//

import Foundation

class VFont: NSObject {
    
}
extension UIFont {
    
    /// 使用Din字体
    /// - Parameter fontSize: 字体大小
    /// - Returns: 回调
    public static func dinFont(ofSize fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "din-bold", size: fontSize) { return font }
        if !registerFont(bundle: Bundle.init(for: VFont.self), fontName: "din-bold", fontExtension: "otf") {}
        guard let font = UIFont(name: "din-bold", size: fontSize) else {return .boldSystemFont(ofSize: fontSize)}
        return font
    }
    
    
    /// 注册字体
    /// - Parameters:
    ///   - bundle: 字体所在的Bundle
    ///   - fontName: 字体名字
    ///   - fontExtension: 字体文件后缀
    /// - Returns: 注册回调
    public static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("找不到字体\(fontName)")
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("无法从字体:\(fontName) 加载数据")
        }

        guard let font = CGFont(fontDataProvider) else {
            fatalError("无法从数据创建字体")
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            print("注册字体错误:可能已经注册了.")
            return false
        }
        return true
    }
}
