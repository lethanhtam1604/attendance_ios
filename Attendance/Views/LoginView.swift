//
//  LoginView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class LoginView: UIView {

    let scrollView = UIScrollView()
    let containerView = UIView()

    let iconImgView = UIImageView()
    let errorLabel = UILabel()

    let mailView = UIView()
    let mailField = UITextField()
    let mailAbstract = UIView()
    let mailImgView = UIImageView()
    let mailBorder = UIView()

    let passwordView = UIView()
    let passwordField = UITextField()
    let passwordAbstract = UIView()
    let keyImgView = UIImageView()
    let passwordBorder = UIView()

    let forgotButton = UIButton()
    let signInButton = UIButton()
    let orLabel = UILabel()
    let newUserButton = UIButton()

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

        keyImgView.clipsToBounds = true
        keyImgView.contentMode = .scaleAspectFit
        keyImgView.image = UIImage(named: "Key")

        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true

        mailField.textAlignment = .center
        mailField.placeholder = "Email"
        mailField.textColor = UIColor.black
        mailField.returnKeyType = .next
        mailField.keyboardType = .emailAddress
        mailField.inputAccessoryView = UIView()
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.font = UIFont(name: "OpenSans", size: 17)
        mailBorder.backgroundColor = Global.colorSeparator
        mailAbstract.backgroundColor = UIColor.white
        mailView.bringSubview(toFront: mailAbstract)

        passwordField.textAlignment = .center
        passwordField.placeholder = "Password"
        passwordField.textColor = UIColor.black
        passwordField.returnKeyType = .go
        passwordField.keyboardType = .default
        passwordField.isSecureTextEntry = true
        passwordField.inputAccessoryView = UIView()
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.font = UIFont(name: "OpenSans", size: 17)
        passwordBorder.backgroundColor = Global.colorSeparator
        passwordAbstract.backgroundColor = UIColor.white
        passwordView.bringSubview(toFront: passwordAbstract)

        signInButton.setTitle("LOGIN", for: .normal)
        signInButton.backgroundColor = Global.colorMain
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.setTitleColor(Global.colorSelected, for: .highlighted)
        signInButton.layer.cornerRadius = 5
        signInButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        signInButton.clipsToBounds = true

        orLabel.text = "OR"
        orLabel.font = UIFont(name: "OpenSans", size: 15)
        orLabel.textAlignment = .center
        orLabel.textColor = Global.colorGray
        orLabel.adjustsFontSizeToFitWidth = true

        newUserButton.setTitle("CREATE A NEW ACCOUNT", for: .normal)
        newUserButton.setTitleColor(Global.colorMain, for: .normal)
        newUserButton.setTitleColor(Global.colorSelected, for: .highlighted)
        newUserButton.layer.cornerRadius = 5
        newUserButton.clipsToBounds = true
        newUserButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        newUserButton.layer.borderColor = Global.colorMain.cgColor
        newUserButton.layer.borderWidth = 0.8

        forgotButton.setTitle("Forgot Password?", for: .normal)
        forgotButton.setTitleColor(Global.colorGray, for: .normal)
        forgotButton.setTitleColor(Global.colorMain, for: .highlighted)
        forgotButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15)
        forgotButton.sizeToFit()
        forgotButton.contentHorizontalAlignment = .center

        mailAbstract.addSubview(mailImgView)
        mailView.addSubview(mailField)
        mailView.addSubview(mailBorder)
        mailView.addSubview(mailAbstract)

        passwordAbstract.addSubview(keyImgView)
        passwordView.addSubview(passwordField)
        passwordView.addSubview(passwordBorder)
        passwordView.addSubview(passwordAbstract)

        containerView.addSubview(iconImgView)
        containerView.addSubview(orLabel)
        containerView.addSubview(errorLabel)
        containerView.addSubview(mailView)
        containerView.addSubview(passwordView)
        containerView.addSubview(forgotButton)
        containerView.addSubview(signInButton)
        containerView.addSubview(newUserButton)
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

            mailView.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 20)
            mailView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            mailView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
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

            passwordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            passwordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            passwordView.autoPinEdge(.top, to: .bottom, of: mailView, withOffset: 10)
            passwordView.autoSetDimension(.height, toSize: fieldSize)

            passwordField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            passwordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            passwordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            passwordField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

            passwordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            passwordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            passwordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            passwordAbstract.autoSetDimension(.width, toSize: 25)

            keyImgView.autoPinEdge(toSuperviewEdge: .top, withInset: fieldAlign)
            keyImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            keyImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))

            passwordBorder.autoPinEdge(toSuperviewEdge: .left)
            passwordBorder.autoPinEdge(toSuperviewEdge: .right)
            passwordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            passwordBorder.autoSetDimension(.height, toSize: 0.7)

            //---------------------------------------------------------------------------

            signInButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            signInButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            signInButton.autoPinEdge(.top, to: .bottom, of: passwordView, withOffset: 30)
            signInButton.autoSetDimension(.height, toSize: buttonSize)

            //---------------------------------------------------------------------------

            orLabel.autoPinEdge(toSuperviewEdge: .left)
            orLabel.autoPinEdge(toSuperviewEdge: .right)
            orLabel.autoPinEdge(.top, to: .bottom, of: signInButton, withOffset: 10)
            orLabel.autoSetDimension(.height, toSize: 30)

            //---------------------------------------------------------------------------

            newUserButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha - 2)
            newUserButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha - 2)
            newUserButton.autoPinEdge(.top, to: .bottom, of: orLabel, withOffset: 10)
            newUserButton.autoSetDimension(.height, toSize: buttonSize)

            //---------------------------------------------------------------------------

            forgotButton.autoPinEdge(.top, to: .bottom, of: newUserButton, withOffset: 20)
            forgotButton.autoAlignAxis(toSuperviewAxis: .vertical)
            forgotButton.autoSetDimension(.height, toSize: 30)
        }
    }
}
