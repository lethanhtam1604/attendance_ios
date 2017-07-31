//
//  GradientView.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 10/3/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit

public class GradientView: UIView {
    private let gradientBackground = CAGradientLayer()

    var autoFit = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    public init(autoFit: Bool) {
        super.init(frame: .zero)
        self.commonInit()
        self.autoFit = autoFit
    }
    
    func commonInit() {
        gradientBackground.colors = [Global.colorMain.cgColor, Global.colorSecond.cgColor]
        gradientBackground.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientBackground.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.addSublayer(gradientBackground)
        isUserInteractionEnabled = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientBackground.frame = bounds
    }
    
    func config(startpoint: CGPoint, endpoint : CGPoint, colors: [CGColor]){
        self.gradientBackground.colors = colors
        self.gradientBackground.startPoint = startpoint
        self.gradientBackground.endPoint = endpoint
        self.gradientBackground.opacity = 0.5
    }
}
