//
//  VToast.swift
//  VTools
//
//  Created by Jarvis on 2022/2/28.
//

import UIKit

enum ToastPosition {
    case center
    case top
    case bottom
}

 let sizelabel: CGFloat = 13.0
 let sizeSpace: CGFloat = 60.0

public class VToast: UIView {
    static var shared = VToast()
    var messageFont: UIFont = .systemFont(ofSize: 12.0)
    var timer: Timer?
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = messageFont
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.shadowColor = .darkGray
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.autoresizingMask = .flexibleTopMargin
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()
    
    
    
    func show(text: String, postion: ToastPosition = .center, autoHidden: Bool = true) {
        guard text.count > 0 else {return}
        self.hidden()
        
        guard let keyWindow = VTool.App.keyWindow() else { return }
        keyWindow.addSubview(textLabel)
        textLabel.text = text
        textLabel.font = messageFont
        let size = NSString(string: text).boundingRect(with: CGSize(width: keyWindow.width - 40, height: 200), options: .usesLineFragmentOrigin, attributes: [.font: messageFont], context: nil).size
        
        ///  实际宽高
        let labelWidth = size.width + sizelabel * 2
        let labelHeight = size.height + sizelabel * 2
        
        let labelX = (keyWindow.width - labelWidth) / 2
        var labelY = 20.0 + 44.0 + sizeSpace
        
        switch postion {
        case .top:
            labelY = 20.0 + 44.0 + sizeSpace
            break
        case .center:
            labelY = (keyWindow.height - labelHeight) / 2
            break
        case .bottom:
            labelY = keyWindow.height - labelHeight - sizeSpace - VDevice.bottomHeight
            break
        }
        
        textLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        
        keyWindow.addSubview(button)
        button.frame = textLabel.frame
        if autoHidden == true {
            createTime()
        }
    }
    
    func hidden() {
        textLabel.removeFromSuperview()
        button.removeFromSuperview()
        cancelTime()
    }
    
    func createTime() {
        guard timer == nil else {return}
        timer = Timer.vscheduledTimer(withTimeInterval: 2, repeats: false, block: {[weak self] time in
            guard let self = self else { return }
            self.hidden()
        })
    }
    
    func cancelTime() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func buttonTap() {
        self.hidden()
    }
}

extension VToast {
    
    /// Toast 提示 偏上
    /// - Parameter title: 提示内容
    public static func showTop(_ title: String,autoHidden:Bool = true) {
        VToast.shared.show(text: title, postion: .top,autoHidden: autoHidden)
    }
    
    
    /// Toast 提示 居中
    /// - Parameter title: 提示内容
    public static func show(_ title: String,autoHidden:Bool = true) {
        VToast.shared.show(text: title,autoHidden: autoHidden)
    }
    
    
    /// Toast 提示 底部
    /// - Parameter title: 提示内容
    public static func showBottom(_ title: String, autoHidden:Bool = true) {
        VToast.shared.show(text: title, postion: .bottom, autoHidden: autoHidden)
    }
    
    public static func hidden() {
        VToast.shared.hidden()
    }
}
