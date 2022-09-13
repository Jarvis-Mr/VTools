//
//  Button.swift
//  VTools
//
//  Created by Jarvis on 2022/4/19.
//

import Foundation


public enum VImageAlignment: NSInteger {
    case left = 0
    case top
    case bottom
    case right
}

public class VButton: UIButton {
 
    public var imageAlignment: VImageAlignment = .left
    public var spaceBetweenTitleAndImage: CGFloat = 0
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let space: CGFloat = self.spaceBetweenTitleAndImage
        
        let titleW: CGFloat = self.titleLabel?.bounds.width ?? 0
        let titleH: CGFloat = self.titleLabel?.bounds.height ?? 0
        
        let imageW: CGFloat = self.imageView?.bounds.width ?? 0
        let imageH: CGFloat = self.imageView?.bounds.height ?? 0
        
        let btnCenterX: CGFloat = self.bounds.width / 2
        let imageCenterX: CGFloat = btnCenterX - titleW / 2
        let titleCenterX = btnCenterX + imageW / 2
        
        switch self.imageAlignment {
        case .top:
            self.contentEdgeInsets = UIEdgeInsets(top: space / 2, left: 0, bottom: space / 2, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: imageH / 2 + space / 2, left: -(titleCenterX - btnCenterX), bottom: -(imageH/2 + space/2), right: titleCenterX-btnCenterX)
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleH / 2 + space / 2), left: btnCenterX - imageCenterX, bottom: titleH / 2 + space / 2, right: -(btnCenterX - imageCenterX));
//            self.contentEdgeInsets = UIEdgeInsets(top: titleH / 2, left: 20, bottom: 0, right: 20)
        case .left:
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: space / 2)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: -space / 2);
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2, bottom: 0, right: space);
//            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: imageW + space / 2, bottom: 0, right: imageW + space / 2)
        case .bottom:
            self.contentEdgeInsets = UIEdgeInsets(top: space / 2, left: 0, bottom: space / 2, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: -(imageH / 2 + space / 2), left: -(titleCenterX - btnCenterX), bottom: imageH / 2 + space / 2, right: titleCenterX - btnCenterX);
            self.imageEdgeInsets = UIEdgeInsets(top: titleH / 2 + space / 2, left: btnCenterX - imageCenterX,bottom: -(titleH / 2 + space / 2), right: -(btnCenterX - imageCenterX));
        case .right:
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: space / 2)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageW + space / 2), bottom: 0, right: imageW + space / 2);
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleW + space / 2, bottom: 0, right: -(titleW + space / 2));
        }
    }
 
}

extension UIButton {
    
    /// 设置Button标题与图片的位置
    /// - Parameters:
    ///   - alignment: 方向
    ///   - space: 间隔
    public func setupButtonImageAndTitle(alignment: VImageAlignment = .left, space: CGFloat) {
        
        let imageRect: CGRect = self.imageView?.frame ?? CGRect.init()
        let titleRect: CGRect = self.titleLabel?.frame ?? CGRect.init()
        let selfWidth: CGFloat = self.frame.size.width
        let selfHeight: CGFloat = self.frame.size.height
        let totalHeight = titleRect.size.height + space + imageRect.size.height
        
        switch alignment {
        case .left:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: -space / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2, bottom: 0, right: space / 2)
        case .right:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.size.width + space/2), bottom: 0, right: (imageRect.size.width + space/2))
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (titleRect.size.width + space / 2), bottom: 0, right: -(titleRect.size.width +  space/2))
        case .top :
            self.titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + imageRect.size.height + space - titleRect.origin.y), left: (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, bottom: -((selfHeight - totalHeight) / 2 + imageRect.size.height + space - titleRect.origin.y), right: -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - imageRect.origin.y), left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), bottom: -((selfHeight - totalHeight) / 2 - imageRect.origin.y), right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
        case .bottom:
            self.titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - titleRect.origin.y), left: (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2, bottom: -((selfHeight - totalHeight) / 2 - titleRect.origin.y), right: -(selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + titleRect.size.height + space - imageRect.origin.y), left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), bottom: -((selfHeight - totalHeight) / 2 + titleRect.size.height + space - imageRect.origin.y), right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
        }
    }
}
