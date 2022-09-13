//
//  UIColor.swift
//  VTools
//
//  Created by Jarvis on 2021/11/25.
//

import Foundation

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
    
    /// 0x开头的数值
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff, a: alpha)
    }
    
    /// 16进制转颜色
    convenience init(hex hexStr: String, alpha: CGFloat = 1.0) {
        //处理数值

        var cString = hexStr.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }

        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }

        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2

        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)

        range.location = 4
        let bString = (cString as NSString).substring(with: range)

        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    
    /// 获取修改透明值之后的颜色
    /// - Parameter alpha: 透明度
    /// - Returns: 返回修改后的颜色对象
    func update(alpha: CGFloat)-> UIColor {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// 随机色
    static var random: UIColor {
      return UIColor(red: CGFloat.random(in: 0...1),
                     green: CGFloat.random(in: 0...1),
                     blue: CGFloat.random(in: 0...1),
                     alpha: 1.0)
    }
}
