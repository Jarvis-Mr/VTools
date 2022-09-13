//
//  UIImage.swift
//  VTools
//
//  Created by Jarvis on 2021/11/25.
//

import UIKit

public extension UIImage {

    /// 视图View生成UIImage
    convenience init(view: UIView, scale: CGFloat = 0) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, scale)
        
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            if let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
                self.init(cgImage: cgImage)
                UIGraphicsEndImageContext()
                return
            }
        }
        self.init()
    }

    /// 颜色生成UIImage
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    /// 图片生成指定颜色的图片
    func tinted(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        color.set()
        UIRectFillUsingBlendMode(rect, .sourceAtop)
        let tintImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintImage
    }
    
    /// 生成指定大小图像
    func resize(width: CGFloat, height: CGFloat = -1) -> UIImage? {
        if height == -1 {
            let newHeight = width*self.size.height/self.size.width
            UIGraphicsBeginImageContext(CGSize(width: width, height: newHeight))
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: newHeight))
        } else {
            if height/width > self.size.height/self.size.width {
                let expectedWidth = width*self.size.height/height
                let left = self.size.width/2-expectedWidth/2
                
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                
                let cropRegion = CGRect(x: left, y: 0, width: expectedWidth, height: self.size.height)
                if let cgImage = self.cgImage?.cropping(to: cropRegion) {
                    let croppedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: self.imageOrientation)
                    croppedImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                }
            } else {
                let expectedHeight = height*self.size.width/width
                let top = self.size.height/2-expectedHeight/2
                
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                
                let cropRegion = CGRect(x: 0, y: top, width: self.size.width, height: expectedHeight)
                if let cgImage = self.cgImage?.cropping(to: cropRegion) {
                    let croppedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: self.imageOrientation)
                    croppedImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                }
            }
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    /// 生成旋转角度的UIImage
    func rotated(by rotationAngle: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: self.size))
        rotatedViewBox.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let size = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        if let bitmap = UIGraphicsGetCurrentContext() {
            bitmap.translateBy(x: size.width / 2.0, y: size.height / 2.0)
            bitmap.rotate(by: rotationAngle)
            bitmap.scaleBy(x: 1.0, y: -1.0)
            
            let origin = CGPoint(x: -self.size.width / 2.0, y: -self.size.height / 2.0)
            
            bitmap.draw(cgImage, in: CGRect(origin: origin, size: self.size))
        }
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage
        } else {
            UIGraphicsEndImageContext()
            return nil
        }
    }
    
    /// 生成渐变图片
    convenience init?(gradientColors:[UIColor], size:CGSize = CGSize(width: 20, height: 20) )
        {
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            let context = UIGraphicsGetCurrentContext()
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = gradientColors.map {(color: UIColor) in return color.cgColor  } as CFArray
            
            if let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: nil) {
                // 第二个参数是起始位置，第三个参数是终止位置
                context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: 0), options: CGGradientDrawingOptions(rawValue: 0))
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard let cgImage = image?.cgImage else { return nil }
            self.init(cgImage: cgImage)
        }
}

public extension UIImage {
    
    /// APP icon
    static var icon: UIImage? {
        if let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    
    static var launchImage: UIImage? {
        if let image = assetsLaunchImage() {
            return image
        }
        if let image = storyboardLaunchImage() {
            return image
        }
        return nil
    }
    
    /// From Assets
    static private func assetsLaunchImage() -> UIImage? {
        if let image = assetsLaunchImage("Portrait") { return image }
        if let image = assetsLaunchImage("Landscape") { return image }
        return nil
    }
    
    static private func assetsLaunchImage(_ orientation: String) -> UIImage? {
        let size = UIScreen.main.bounds.size
        guard let launchImages = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else { return nil }
        for dict in launchImages {
            let imageSize = NSCoder.cgSize(for: dict["UILaunchImageSize"] as! String)
            if __CGSizeEqualToSize(imageSize, size) && orientation == (dict["UILaunchImageOrientation"] as! String) {
                let launchImageName = dict["UILaunchImageName"] as! String
                let image = UIImage(named: launchImageName)
                return image
            }
        }
        return nil
    }
    /// LaunchScreen.Storyboard 生成图片
    static private func storyboardLaunchImage() -> UIImage? {
        guard let storyboardLaunchName = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String,
            let launchVC = UIStoryboard(name: storyboardLaunchName, bundle: nil).instantiateInitialViewController(),
            let view = launchVC.view else {
                return nil
        }
        
        view.frame = UIScreen.main.bounds
        let image = viewConvertImage(view: view)
        return image
    }
    
    /// 视图转图片
    static private func viewConvertImage(view: UIView) -> UIImage? {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

/// 二维码生成
public extension UIImage {
    
    /// 二维码生成
    /// - Parameters:
    ///   - info: 生成二维码的数据
    ///   - width: 二维码尺寸
    ///   - centerImage: 中间图片
    /// - Returns: image
    static func genderQrcode(info: String, width: CGFloat = 200, centerImage:UIImage? = nil) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil}
        guard let data = info.data(using: .utf8, allowLossyConversion: true) else {return nil}
        filter.setDefaults()
        filter.setValue(data, forKeyPath: "inputMessage")
        /// 获取二维码过滤器生成的二维码
        guard let ciimage = filter.outputImage else { return nil}
        guard let image = createImage(ciimage: ciimage, width: width) else { return nil}
                
        /// 绘制中间图标
        UIGraphicsBeginImageContext(image.size)
        //5.2将二维码的图片画入
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        if let centerImage = centerImage {
            let centerW = image.size.width * 0.2
            let centerH = centerW
            let centerX = (image.size.width - centerW) * 0.5
            let centerY = (image.size.height - centerH) * 0.5
            centerImage.draw(in: CGRect(x: centerX, y: centerY, width: centerW, height: centerH))
        }
        //5.3获取绘制好的图片
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        //5.4关闭图像上下文
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    /// 根据CIImage生成指定大小的UIImage
    /// - Parameters:
    ///   - ciimage: CIImage
    ///   - width: 图片宽度
    /// - Returns: 
    static func createImage(ciimage: CIImage, width: CGFloat) -> UIImage? {
        let extent = ciimage.extent.integral
        let scale = min(width/extent.width, width/extent.height)
        
        let width = size_t(extent.width * scale)
        let height = size_t(extent.height * scale)
        let cs = CGColorSpaceCreateDeviceGray()
        let bitmap: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 1)!
               
        ///
        let context = CIContext.init()
        let bitmapImage = context.createCGImage(ciimage, from: extent)
        bitmap.interpolationQuality = .none
        bitmap.scaleBy(x: scale, y: scale)
        bitmap.draw(bitmapImage!, in: extent)
        guard let scaledImage = bitmap.makeImage() else {return nil}
        
        return UIImage.init(cgImage: scaledImage)
        
    }
    
}
