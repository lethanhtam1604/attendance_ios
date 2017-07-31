//
//  SplashScreenView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class SplashScreenView: UIView {

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor.white

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
        }
    }
}
