//
//  Label.swift
//  VTools
//
//  Created by Jarvis on 2022/4/15.
//

import Foundation
import UIKit

extension UILabel {
    func labelHeight(width:CGFloat) -> CGFloat{
        let size = CGSize(width: width, height: 0)
        let rect = text!.boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [.font : font as Any], context: nil)
        return CGFloat(ceilf(Float(rect.size.height)))
    }
    
    func labelWidth() -> CGFloat{
        let size = CGSize(width: 0, height: 0)
        let rect = text!.boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [.font : font as Any], context: nil)
        return CGFloat(ceilf(Float(rect.size.width)))
    }
    
    public func setLineSpacing(lineSpacing: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedString.length))
  
//        print("attributed string \(attributedString)")
        self.attributedText = attributedString
    }
}

public class VLabel: UILabel {
    public var lineSpacing: CGFloat = 5
    public override init(frame: CGRect) {
        super.init(frame: frame)
        lineBreakMode = .byWordWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLineSpacing(lineSpacing: lineSpacing)
    }
}
