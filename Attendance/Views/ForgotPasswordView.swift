//
//  ForgotPasswordView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class ForgotPasswordView: UIView {

    let scrollView = UIScrollView()
    let containerView = UIView()

    let iconImgView = UIImageView()
    let errorLabel = UILabel()
    let titleLabel = UILabel()

    let mailView = UIView()
    let mailField = UITextField()
    let mailAbstract = UIView()
    let mailImgView = UIImageView()
    let mailBorder = UIView()

    let recoverPasswordButton = UIButton()

    let backToSignInView = UIView()
    let backToButton = UIButton()
    let signInButton = UIButton()

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor.white
        tintColor = Global.colorMain
        addTapToDismiss()

        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = UIImage(named: "Icon")

        mailImgView.clipsToBounds = true
        mailImgView.contentMode = .scaleAspectFit
        mailImgView.image = UIImage(named: "Mail")

        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true

        titleLabel.text = "Enter your email id to reset your password"
        titleLabel.font = UIFont(name: "OpenSans", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0

        mailField.textAlignment = .center
        mailField.placeholder = "Email"
        mailField.textColor = UIColor.black
        mailField.returnKeyType = .go
        mailField.keyboardType = .emailAddress
        mailField.inputAccessoryView = UIView()
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.font = UIFont(name: "OpenSans", size: 17)
        mailBorder.backgroundColor = Global.colorSeparator
        mailAbstract.backgroundColor = UIColor.white
        mailView.bringSubview(toFront: mailAbstract)

        recoverPasswordButton.setTitle("RECOVER PASSWORD", for: .normal)
        recoverPasswordButton.backgroundColor = Global.colorMain
        recoverPasswordButton.setTitleColor(UIColor.white, for: .normal)
        recoverPasswordButton.setTitleColor(Global.colorSelected, for: .highlighted)
        recoverPasswordButton.layer.cornerRadius = 5
        recoverPasswordButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        recoverPasswordButton.clipsToBounds = true

        backToButton.setTitle("Go back to", for: .normal)
        backToButton.setTitleColor(Global.colorGray, for: .normal)
        backToButton.setTitleColor(Global.colorMain, for: .highlighted)
        backToButton.isUserInteractionEnabled = false
        backToButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        backToButton.sizeToFit()
        backToButton.contentHorizontalAlignment = .center

        signInButton.setTitle("LOGIN", for: .normal)
        signInButton.setTitleColor(Global.colorMain, for: .normal)
        signInButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signInButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        signInButton.sizeToFit()
        signInButton.contentHorizontalAlignment = .center


        mailAbstract.addSubview(mailImgView)
        mailView.addSubview(mailField)
        mailView.addSubview(mailBorder)
        mailView.addSubview(mailAbstract)

        backToSignInView.addSubview(backToButton)
        backToSignInView.addSubview(signInButton)

        containerView.addSubview(iconImgView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(mailView)
        containerView.addSubview(recoverPasswordButton)
        containerView.addSubview(backToSignInView)
        scrollView.addSubview(containerView)

        addSubview(scrollView)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            scrollView.autoPinEdgesToSuperviewEdges()

            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: self)

            var alpha: CGFloat = 40
            var buttonSize: CGFloat = 40
            var fieldSize: CGFloat = 40
            var fieldAlign: CGFloat = 12
            var imageSize: CGFloat = 100

            if DeviceType.IS_IPAD {
                alpha = 100
                buttonSize = 50
                fieldSize = 50
                fieldAlign = 17
                imageSize = 200
            }

            iconImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 50)
            iconImgView.autoSetDimensions(to: CGSize(width: imageSize, height: imageSize))
            iconImgView.autoAlignAxis(toSuperviewAxis: .vertical)

            //---------------------------------------------------------------------------

            errorLabel.autoPinEdge(.top, to: .bottom, of: iconImgView, withOffset: 30)
            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoSetDimension(.height, toSize: 20)

            //---------------------------------------------------------------------------

            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 65)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 65)
            titleLabel.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 20)

            //---------------------------------------------------------------------------

            mailView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            mailView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            mailView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
            mailView.autoSetDimension(.height, toSize: fieldSize)

            mailField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mailField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            mailField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mailField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

            mailAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            mailAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            mailAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            mailAbstract.autoSetDimension(.width, toSize: 25)

            mailImgView.autoPinEdge(toSuperviewEdge: .top, withInset: fieldAlign)
            mailImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            mailImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))

            mailBorder.autoPinEdge(toSuperviewEdge: .left)
            mailBorder.autoPinEdge(toSuperviewEdge: .right)
            mailBorder.autoPinEdge(toSuperviewEdge: .bottom)
            mailBorder.autoSetDimension(.height, toSize: 0.7)

            //---------------------------------------------------------------------------

            recoverPasswordButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            recoverPasswordButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            recoverPasswordButton.autoPinEdge(.top, to: .bottom, of: mailView, withOffset: 40)
            recoverPasswordButton.autoSetDimension(.height, toSize: buttonSize)

            //---------------------------------------------------------------------------

            backToButton.autoPinEdge(toSuperviewEdge: .top)
            backToButton.autoPinEdge(toSuperviewEdge: .left)
            backToButton.autoSetDimension(.height, toSize: 30)

            signInButton.autoPinEdge(toSuperviewEdge: .top)
            signInButton.autoPinEdge(toSuperviewEdge: .right)
            signInButton.autoPinEdge(.left, to: .right, of: backToButton, withOffset: 5)
            signInButton.autoSetDimension(.height, toSize: 30)

            backToSignInView.autoPinEdge(.top, to: .bottom, of: recoverPasswordButton, withOffset: 20)
            backToSignInView.autoAlignAxis(toSuperviewAxis: .vertical)
            backToSignInView.autoSetDimension(.height, toSize: 30)
        }
    }
}
