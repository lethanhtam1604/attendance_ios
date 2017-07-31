
//
//  CaptureButton.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 9/23/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import QuartzCore
import PureLayout

public protocol CaptureButtonDelegate {
    func shouldTakePicture()
    func shouldCaptureVideo()
    func shouldStopCapturingVideo()
}

public class CaptureButton: UIView {
    private var constraintsAdded = false
    private let innerButton = UIButton()
    private var captureTimer : Timer?
    private var holding = false
    private var capturing = false

    private var constraintsLeft   : NSLayoutConstraint!
    private var constraintsRight  : NSLayoutConstraint!
    private var constraintsTop    : NSLayoutConstraint!
    private var constraintsBottom : NSLayoutConstraint!
    
    public var shadowOffset = CGSize.zero {
        didSet {
            self.layer.shadowOffset = shadowOffset
            innerButton.layer.shadowOffset = shadowOffset
        }
    }
    
    public var icon : UIImage? {
        didSet {
            self.innerButton.setImage(icon, for: .normal)
        }
    }
    
    public var enabled = false {
        didSet {
            self.innerButton.isEnabled = enabled
       
        }
    }
    
    public var delegate : CaptureButtonDelegate?

    
    public init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        self.addSubview(innerButton)
 
        innerButton.backgroundColor = UIColor.white
        innerButton.layer.shadowColor = UIColor.black.cgColor
        innerButton.layer.shadowRadius = 3
        innerButton.layer.shadowOpacity = 0.8
        
        innerButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
        innerButton.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        innerButton.addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
    }
    
    public override func updateConstraints() {
        if !constraintsAdded {
            constraintsAdded = true
            
            constraintsLeft   = innerButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            constraintsRight  = innerButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            constraintsTop    = innerButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            constraintsBottom = innerButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        }
        super.updateConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.size.width / 2
        innerButton.layer.cornerRadius = (frame.size.width - 2 * constraintsLeft.constant) / 2
    }
    
    
    func touchDown() {
        holding = true
        innerButton.backgroundColor = UIColor.red
        
        captureTimer?.invalidate()
        captureTimer = Timer.scheduledTimer(timeInterval: 0.3,
                                                              target: self,
                                                              selector: #selector(capture),
                                                              userInfo: nil,
                                                              repeats: false)
    }
    
    func touchUp() {
        if capturing {
            capturing = false
            
            constraintsLeft.constant = 10
            constraintsRight.constant = -10
            constraintsTop.constant = 10
            constraintsBottom.constant = -10
            
            UIView.animate(withDuration: 0.3, animations: {
                self.setNeedsUpdateConstraints()
            })
            
            delegate?.shouldStopCapturingVideo()
        }
        holding = false
        innerButton.backgroundColor = UIColor.white
    }
    
    func capture() {
        if holding {
            capturing = true

            constraintsLeft.constant = 0
            constraintsRight.constant = 0
            constraintsTop.constant = 0
            constraintsBottom.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.setNeedsUpdateConstraints()
            })
            
            delegate?.shouldCaptureVideo()
        } else {
            delegate?.shouldTakePicture()
        }
    }
}
