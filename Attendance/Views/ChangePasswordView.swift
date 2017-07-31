//
//  ChangePasswordView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/5/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class ChangePasswordView: UIView {

    let scrollView = UIScrollView()
    let containerView = UIView()
    let topView = UIView()

    let errorLabel = UILabel()

    let previousPasswordView = UIView()
    let previousPasswordField = UITextField()
    let previousPasswordBorder = UIView()
    let previousPassowrdImgView = UIImageView()
    let previousPasswordAbstract = UIView()

    let newPasswordView = UIView()
    let newPasswordField = UITextField()
    let newPasswordBorder = UIView()
    let newPassowrdImgView = UIImageView()
    let newPasswordAbstract = UIView()

    let confirmPasswordView = UIView()
    let confirmPasswordField = UITextField()
    let confirmPasswordBorder = UIView()
    let confirmPassowrdImgView = UIImageView()
    let confirmPasswordAbstract = UIView()

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorBg
        tintColor = Global.colorMain
        addTapToDismiss()

        containerView.backgroundColor = UIColor.white
        topView.backgroundColor = Global.colorSeparator

        previousPassowrdImgView.clipsToBounds = true
        previousPassowrdImgView.contentMode = .scaleAspectFit
        previousPassowrdImgView.image = UIImage(named: "Key")

        newPassowrdImgView.clipsToBounds = true
        newPassowrdImgView.contentMode = .scaleAspectFit
        newPassowrdImgView.image = UIImage(named: "Key")

        confirmPassowrdImgView.clipsToBounds = true
        confirmPassowrdImgView.contentMode = .scaleAspectFit
        confirmPassowrdImgView.image = UIImage(named: "Key")

        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true

        previousPasswordField.textAlignment = .center
        previousPasswordField.placeholder = "Current Password"
        previousPasswordField.textColor = UIColor.black
        previousPasswordField.returnKeyType = .next
        previousPasswordField.keyboardType = .namePhonePad
        previousPasswordField.isSecureTextEntry = true
        previousPasswordField.inputAccessoryView = UIView()
        previousPasswordField.autocorrectionType = .no
        previousPasswordField.autocapitalizationType = .none
        previousPasswordField.font = UIFont(name: "OpenSans", size: 17)
        previousPasswordBorder.backgroundColor = Global.colorSeparator
        previousPasswordAbstract.backgroundColor = UIColor.white
        previousPasswordView.bringSubview(toFront: previousPasswordAbstract)

        newPasswordField.textAlignment = .center
        newPasswordField.placeholder = "New Password"
        newPasswordField.textColor = UIColor.black
        newPasswordField.returnKeyType = .next
        newPasswordField.keyboardType = .namePhonePad
        newPasswordField.isSecureTextEntry = true
        newPasswordField.inputAccessoryView = UIView()
        newPasswordField.autocorrectionType = .no
        newPasswordField.autocapitalizationType = .none
        newPasswordField.font = UIFont(name: "OpenSans", size: 17)
        newPasswordBorder.backgroundColor = Global.colorSeparator
        newPasswordAbstract.backgroundColor = UIColor.white
        newPasswordView.bringSubview(toFront: newPasswordAbstract)

        confirmPasswordField.textAlignment = .center
        confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.textColor = UIColor.black
        confirmPasswordField.returnKeyType = .done
        confirmPasswordField.keyboardType = .namePhonePad
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.inputAccessoryView = UIView()
        confirmPasswordField.autocorrectionType = .no
        confirmPasswordField.autocapitalizationType = .none
        confirmPasswordField.font = UIFont(name: "OpenSans", size: 17)
        confirmPasswordBorder.backgroundColor = Global.colorSeparator
        confirmPasswordAbstract.backgroundColor = UIColor.white
        confirmPasswordView.bringSubview(toFront: confirmPasswordAbstract)

        previousPasswordView.addSubview(previousPasswordField)
        previousPasswordView.addSubview(previousPasswordBorder)
        previousPasswordView.addSubview(previousPasswordAbstract)
        previousPasswordView.addSubview(previousPassowrdImgView)

        newPasswordView.addSubview(newPasswordField)
        newPasswordView.addSubview(newPasswordBorder)
        newPasswordView.addSubview(newPasswordAbstract)
        newPasswordView.addSubview(newPassowrdImgView)

        confirmPasswordView.addSubview(confirmPasswordField)
        confirmPasswordView.addSubview(confirmPasswordBorder)
        confirmPasswordView.addSubview(confirmPasswordAbstract)
        confirmPasswordView.addSubview(confirmPassowrdImgView)

        containerView.addSubview(topView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(previousPasswordView)
        containerView.addSubview(newPasswordView)
        containerView.addSubview(confirmPasswordView)

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
            var fieldSize: CGFloat = 40
            var fieldAlign: CGFloat = 12

            if DeviceType.IS_IPAD {
                alpha = 100
                fieldSize = 50
                fieldAlign = 17
            }

            topView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            topView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            topView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            topView.autoSetDimension(.height, toSize: 0.5)

            //---------------------------------------------------------------------------

            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            errorLabel.autoSetDimension(.height, toSize: 20)

            //---------------------------------------------------------------------------

            previousPasswordView.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 10)
            previousPasswordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            previousPasswordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            previousPasswordView.autoSetDimension(.height, toSize: fieldSize)

            previousPasswordField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            previousPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            previousPasswordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            previousPasswordField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

            previousPasswordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            previousPasswordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            previousPasswordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            previousPasswordAbstract.autoSetDimension(.width, toSize: 25)

            previousPassowrdImgView.autoPinEdge(toSuperviewEdge: .top, withInset: fieldAlign)
            previousPassowrdImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            previousPassowrdImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))

            previousPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
            previousPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
            previousPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            previousPasswordBorder.autoSetDimension(.height, toSize: 0.7)

            //---------------------------------------------------------------------------

            newPasswordView.autoPinEdge(.top, to: .bottom, of: previousPasswordView, withOffset: 10)
            newPasswordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            newPasswordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            newPasswordView.autoSetDimension(.height, toSize: fieldSize)

            newPasswordField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            newPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            newPasswordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            newPasswordField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

            newPasswordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            newPasswordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            newPasswordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            newPasswordAbstract.autoSetDimension(.width, toSize: 25)

            newPassowrdImgView.autoPinEdge(toSuperviewEdge: .top, withInset: fieldAlign)
            newPassowrdImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            newPassowrdImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))

            newPasswordBorder.autoPinEdge(toSuperviewEdge: .left)
            newPasswordBorder.autoPinEdge(toSuperviewEdge: .right)
            newPasswordBorder.autoPinEdge(toSuperviewEdge: .bottom)
            newPasswordBorder.autoSetDimension(.height, toSize: 0.7)

            //---------------------------------------------------------------------------

            confirmPasswordView.autoPinEdge(.top, to: .bottom, of: newPasswordView, withOffset: 10)
            confirmPasswordView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            confirmPasswordView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            confirmPasswordView.autoSetDimension(.height, toSize: fieldSize)

            confirmPasswordField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            confirmPasswordField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

            confirmPasswordAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            confirmPasswordAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            confirmPasswordAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            confirmPasswordAbstract.autoSetDimension(.width, toSize: 25)

            confirmPassowrdImgView.autoPinEdge(toSuperviewEdge: .top, withInset: fieldAlign)
            confirmPassowrdImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            confirmPassowrdImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
        }
    }
}
