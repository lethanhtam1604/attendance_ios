//
//  UIView+Extentions.swift
//  yeu-kute-ios-swift
//
//  Created by Nam Truong on 4/30/15.
//  Copyright (c) 2015 Nam Truong. All rights reserved.
//

import UIKit

extension UIView {
    
    func rotate360Degrees(duration: CFTimeInterval = 0.7, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = -CGFloat(M_PI/2)
        rotateAnimation.toValue = 0
        rotateAnimation.duration = duration
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func increaseSize() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1
        animation.fromValue = 0
        animation.duration = 0.3
        animation.autoreverses = false
        self.layer.add(animation, forKey: nil)
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func setBorderColor(color: UIColor){
        self.layer.borderColor = color.cgColor
    }
    
    func setBorderWidth(width: CGFloat){
        self.layer.borderWidth = width
    }
    
    func setCornerRadius(r : CGFloat){
        self.layer.cornerRadius = r
        
    }
    
    // shot
    func snapshot() -> UIImage {
        let size = self.frame.size
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(size)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // keyboard
    func addTapToDismiss() {
        let tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tapViewGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapViewGesture)
    }
    
    func dismiss() {
        endEditing(true)
    }
}

