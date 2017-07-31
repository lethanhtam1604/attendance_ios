//
//  ItemIntroView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/13/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class ItemIntroView: UIView {

    var iconImgView = UIImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var signInButton = UIButton()
    var signUpButton = UIButton()

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        iconImgView.contentMode = .scaleAspectFit
        iconImgView.clipsToBounds = true

        titleLabel.font = UIFont(name: "OpenSans-bold", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = UIFont(name: "OpenSans", size: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0

        signInButton.setTitle("LOGIN", for: .normal)
        signInButton.backgroundColor = UIColor.white
        signInButton.setTitleColor(Global.colorMain, for: .normal)
        signInButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signInButton.layer.cornerRadius = 5
        signInButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        signInButton.clipsToBounds = true

        signUpButton.setTitle("SIGNUP", for: .normal)
        signUpButton.backgroundColor = UIColor.white
        signUpButton.setTitleColor(Global.colorMain, for: .normal)
        signUpButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signUpButton.layer.cornerRadius = 5
        signUpButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        signUpButton.clipsToBounds = true

        addSubview(iconImgView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(signInButton)
        addSubview(signUpButton)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            var buttonSize: CGFloat = 40
            var alpha: CGFloat = 40
            var imgHeight: CGFloat = 200
            var imgWidth: CGFloat = 270
            var imgTop: CGFloat = 100
            var alphaButton: CGFloat = 15
            var distanceButton: CGFloat = 40

            if DeviceType.IS_IPAD {
                buttonSize = 50
                alpha = 150
                imgHeight = 300
                imgWidth = 400
                imgTop = 150
                alphaButton = 40
                distanceButton = 60
            }

            iconImgView.autoPinEdge(toSuperviewEdge: .top, withInset: imgTop)
            iconImgView.autoSetDimensions(to: CGSize(width: imgWidth, height: imgHeight))
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)

            titleLabel.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 10)
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)

            descriptionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)

            signUpButton.autoPinEdge(toSuperviewEdge: .left, withInset: alphaButton)
            signUpButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 70)
            signUpButton.autoMatch(.width, to: .width, of: signInButton)
            signUpButton.autoSetDimension(.height, toSize: buttonSize)

            signInButton.autoPinEdge(toSuperviewEdge: .right, withInset: alphaButton)
            signInButton.autoMatch(.width, to: .width, of: signUpButton)
            signInButton.autoPinEdge(.left, to: .right, of: signUpButton, withOffset: distanceButton)
            signInButton.autoPinEdge(.bottom, to: .bottom, of: signUpButton)
            signInButton.autoMatch(.height, to: .height, of: signUpButton)

        }
    }
}
