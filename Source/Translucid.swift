//
//  Translucid.swift
//  Translucid
//
//  Created by Lucas Ortis on 18/12/2015.
//  Copyright © 2015 Ekhoo. All rights reserved.
//

import UIKit

public class Translucid: UIView {
    
    private let textLayer: CATextLayer = CATextLayer()
    private let imageLayer: CALayer = CALayer()
    
    public var text: String = "Hello World" {
        didSet {
            self.textLayer.string = self.text
            self.autoResizeTextLayer()
        }
    }
    
    public var backgroundImage: UIImage? {
        didSet {
            if let image = backgroundImage {
                self.imageLayer.contents = image.cgImage
            }
        }
    }
    
    public override var frame: CGRect {
        didSet {
            self.imageLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height + 200.0)
            self.textLayer.frame = self.bounds
            self.autoResizeTextLayer()
        }
    }
    
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 20) {
        didSet {
            self.textLayer.font = self.font
            self.autoResizeTextLayer()
        }
    }
    
    public init(text: String, font: UIFont) {
        let textSize = text.size(withAttributes: [.font: font])
        
        super.init(frame: CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height))
        self.text = text
        self.font = font
        
        self.commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    public func animate() {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = NSValue(cgPoint: self.imageLayer.position)
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.imageLayer.position.x, y: self.imageLayer.position.y - 200))
        animation.duration = 15.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        self.imageLayer.add(animation, forKey: "transform")
    }
    
    private func autoResizeTextLayer() {
        var fontSize: CGFloat = 1.0
        
        var rect: CGRect = NSString(string: self.text).boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font.withSize(fontSize)], context: nil)
        
        while rect.size.height < self.bounds.size.height {
            fontSize += 1
            rect = NSString(string: self.text).boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font.withSize(fontSize)], context: nil)
        }
        
        fontSize -= 1
        
        self.textLayer.fontSize = fontSize
        self.textLayer.font = self.font.withSize(fontSize)
    }
    
    private func commonInit() {
        textLayer.borderColor = UIColor.black.cgColor
        textLayer.borderWidth = 5.0
        self.textLayer.string = self.text
        self.textLayer.alignmentMode = .center
        self.textLayer.frame = self.bounds
        self.textLayer.fontSize = self.font.pointSize
        self.textLayer.font = self.font
        self.textLayer.isWrapped = true
        self.textLayer.rasterizationScale = UIScreen.main.scale
        self.textLayer.truncationMode = .end
        self.textLayer.contentsScale = UIScreen.main.scale
        
        self.autoResizeTextLayer()
        
        self.layer.addSublayer(self.imageLayer)
        self.layer.mask = self.textLayer
    }
}
