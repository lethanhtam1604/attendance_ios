//
//  UIImageView.swift
//  Education Platform
//
//  Created by Thanh-Tam Le on 1/11/17.
//  Copyright © 2017 Duy Cao. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func changeSulfur() {
        let visualV = UIVisualEffectView(effect: UIBlurEffect(style: .dark)) as UIVisualEffectView
        visualV.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_HEIGHT, height: self.bounds.height)
        self.addSubview(visualV)
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
