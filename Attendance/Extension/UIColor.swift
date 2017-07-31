//
//  UIColor.swift
//  Signature
//
//  Created by Thanh-Tam Le on 8/31/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

extension UIColor {
    
    var coreImageColor: CoreImage.CIColor {
        return CoreImage.CIColor(color: self)  // The resulting Core Image color, or nil
    }
    
    public convenience init(_ value: Int) {
        let components = getColorComponents(value: value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
}

private func getColorComponents(value: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    let r = CGFloat(value >> 16 & 0xFF) / 255.0
    let g = CGFloat(value >> 8 & 0xFF) / 255.0
    let b = CGFloat(value & 0xFF) / 255.0
    
    return (r, g, b)
}
