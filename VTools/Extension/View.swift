//
//  View.swift
//  VTools
//
//  Created by Jarvis on 2021/11/24.
//

import Foundation
import UIKit

extension UIView {
    /// 一次性添加多个视图
    public  func addSubviews(_ views: UIView...) {
        for item in views {
            self.addSubview(item)
        }
    }
    
    /// 类的名称
    public class func viewIdentifier() -> String {
        return String(describing: self)
    }
}

extension UIView {
    public var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public var left: CGFloat {
        set {
            self.frame = CGRect(x: newValue, y: self.top, width: self.width, height: self.height)
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var top: CGFloat {
        set {
            self.frame = CGRect(x: self.left, y: newValue, width: self.width, height: self.height)
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public var right: CGFloat {
        set {
            self.frame = CGRect(x: newValue - self.width, y: self.top, width: self.width, height: self.height)
        }
        get {
            return self.left + self.width
        }
    }
    
    public var bottom: CGFloat {
        set {
            self.frame = CGRect(x: self.left, y: newValue - self.height, width: self.width, height: self.height)
        }
        get {
            return self.top + self.height
        }
    }
    
    public var centerX: CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    
    public var centerY: CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }
    
   public var width: CGFloat {
        set {
            self.frame.size = CGSize(width: newValue, height: self.frame.height)
        }
        get {
            return self.bounds.size.width
        }
    }
    
    public var height: CGFloat {
        set {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.width, height: newValue))
        }
        get {
            return self.bounds.size.height
        }
    }
    
    public var halfWidth: CGFloat {
        return self.width / 2
    }
    
    public var halfHeight: CGFloat {
        return self.height / 2
    }
    
    public var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
    }
}

extension UIView {
    
    /// 设置渐变色
    /// - Parameter colors: <#colors description#>
    /// - Parameter vertical: 是否从上往下
    public func setGradient(colors: Array<CGColor>, vertical: Bool = true,startPointX: CGFloat = 0, startPointY: CGFloat = 0, endPointX: CGFloat = 0, endPontY: CGFloat = 1) {
        removeGradient()
        guard colors.count > 0 else {return}
        let gradient = CAGradientLayer()
        if vertical {
            gradient.startPoint = CGPoint(x: startPointX, y: startPointY)
            gradient.endPoint = CGPoint(x: endPointX, y: endPontY)
        } else {
            gradient.startPoint = CGPoint(x: startPointX, y: startPointY)
            gradient.endPoint = CGPoint(x: 1, y: 0)
        }
        
        gradient.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        gradient.colors = colors
        layer.insertSublayer(gradient, at: 0)
    }
    
    /// 删除渐变
    public func removeGradient() {
        guard let layers = layer.sublayers else { return }
        for laye in layers {
            if laye is CAGradientLayer {
                laye.removeFromSuperlayer()
            }
        }
    }
    
}

extension UIView {
    /// 绘制虚线
    /// - Parameters:
    ///   - lineView: 添加虚线的view
    ///   - strokeColor: 虚线颜色
    ///   - lineWidth: 虚线宽度
    ///   - lineLength: 每段虚线的长度
    ///   - lineSpacing: 每段虚线的间隔
    public func drawDashLine(strokeColor: UIColor,
                              startX: CGFloat,
                              lineWidth: CGFloat = 0.4,
                              lineLength: Int = 4,
                              lineSpacing: Int = 4) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.width/2, y: self.height/2)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        ///起点
        path.move(to: CGPoint(x: startX, y: 0))
        ///终点
        ///  横向 y = 0
//        path.addLine(to: CGPoint(x: 0, y: 0))
        ///纵向 Y = view 的height
        path.addLine(to: CGPoint(x: startX, y: self.frame.height))
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    /// 删除渐变
    public func removeDashLine() {
        guard let layers = layer.sublayers else { return }
        for laye in layers {
            if laye is CAShapeLayer {
                laye.removeFromSuperlayer()
            }
        }
    }
    
    /// 绘制竖直线
    /// - Parameters:
    ///   - strokeColor: 线颜色
    ///   - lineWidth: 线宽度
    public func drawLine2(strokeColor: UIColor,
                              startX: CGFloat,
                              startY: CGFloat,
                          lineWidth: CGFloat = 0.5) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.width/2, y: self.height/2)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        let path = CGMutablePath()
        ///起点
        path.move(to: CGPoint(x: startX, y: startY))
        ///纵向 Y = view 的height
        ///终点
        path.addLine(to: CGPoint(x: startX, y: self.frame.height))
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIView {
    public func roundCorners(corners: UIRectCorner, radius: CGFloat, size:CGSize) {
       let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension CALayer {
    public func roundCorners(corners: UIRectCorner, radius: CGFloat, size:CGSize) {
       let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        mask = layer
    }
}
