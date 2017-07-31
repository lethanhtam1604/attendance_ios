//
//  ProfileView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/5/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    let scrollView = UIScrollView()
    let containerView = UIView()

    let topView = UIView()
    let errorLabel = UILabel()

    let nameView = UIView()
    let nameAbstract = UIView()
    let nameField = UITextField()
    let userImgView = UIImageView()
    let nameBorder = UIView()

    let mailView = UIView()
    let mailAbstract = UIView()
    let mailField = UITextField()
    let mailImgView = UIImageView()
    let mailBorder = UIView()

    let phoneView = UIView()
    let phoneAbstract = UIView()
    let phoneField = UITextField()
    let phoneImgView = UIImageView()
    let phoneBorder = UIView()

    let changePasswordButton = UIButton()

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorBg
        tintColor = Global.colorMain
        addTapToDismiss()

        containerView.backgroundColor = UIColor.white
        topView.backgroundColor = Global.colorSeparator

        userImgView.clipsToBounds = true
        userImgView.contentMode = .scaleAspectFit
        userImgView.image = UIImage(named: "User")

        mailImgView.clipsToBounds = true
        mailImgView.contentMode = .scaleAspectFit
        mailImgView.image = UIImage(named: "Mail")

        phoneImgView.clipsToBounds = true
        phoneImgView.contentMode = .scaleAspectFit
        phoneImgView.image = UIImage(named: "Phone")

        errorLabel.font = UIFont(name: "OpenSans", size: 14)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.red.withAlphaComponent(0.7)
        errorLabel.adjustsFontSizeToFitWidth = true

        nameField.textAlignment = .center
        nameField.placeholder = "Name"
        nameField.textColor = UIColor.black
        nameField.returnKeyType = .next
        nameField.keyboardType = .namePhonePad
        nameField.inputAccessoryView = UIView()
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .none
        nameField.font = UIFont(name: "OpenSans", size: 17)
        nameBorder.backgroundColor = Global.colorSeparator
        nameAbstract.backgroundColor = UIColor.white
        nameView.bringSubview(toFront: nameAbstract)

        mailField.isUserInteractionEnabled = false
        mailField.textAlignment = .center
        mailField.placeholder = "Email"
        mailField.textColor = Global.colorGray
        mailField.returnKeyType = .next
        mailField.keyboardType = .emailAddress
        mailField.inputAccessoryView = UIView()
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.font = UIFont(name: "OpenSans", size: 17)
        mailBorder.backgroundColor = Global.colorSeparator
        mailAbstract.backgroundColor = UIColor.white
        mailView.bringSubview(toFront: mailAbstract)

        phoneField.textAlignment = .center
        phoneField.placeholder = "Phone"
        phoneField.textColor = UIColor.black
        phoneField.returnKeyType = .next
        phoneField.keyboardType = .phonePad
        phoneField.inputAccessoryView = UIView()
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.font = UIFont(name: "OpenSans", size: 17)
        phoneBorder.backgroundColor = Global.colorSeparator
        phoneAbstract.backgroundColor = UIColor.white
        phoneView.bringSubview(toFront: phoneAbstract)

        changePasswordButton.setTitle("CHANGE PASSWORD", for: .normal)
        changePasswordButton.backgroundColor = Global.colorMain
        changePasswordButton.setTitleColor(UIColor.white, for: .normal)
        changePasswordButton.setTitleColor(Global.colorSelected, for: .highlighted)
        changePasswordButton.layer.cornerRadius = 5
        changePasswordButton.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        changePasswordButton.clipsToBounds = true

        nameAbstract.addSubview(userImgView)
        nameView.addSubview(nameField)
        nameView.addSubview(nameBorder)
        nameView.addSubview(nameAbstract)

        mailAbstract.addSubview(mailImgView)
        mailView.addSubview(mailField)
        mailView.addSubview(mailBorder)
        mailView.addSubview(mailAbstract)

        phoneAbstract.addSubview(phoneImgView)
        phoneView.addSubview(phoneField)
        phoneView.addSubview(phoneBorder)
        phoneView.addSubview(phoneAbstract)

        containerView.addSubview(topView)
        containerView.addSubview(errorLabel)
        containerView.addSubview(nameView)
        containerView.addSubview(mailView)
        containerView.addSubview(phoneView)
        containerView.addSubview(changePasswordButton)

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

            if DeviceType.IS_IPAD {
                alpha = 100
                buttonSize = 50
                fieldSize = 50
                fieldAlign = 17
            }

            topView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            topView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            topView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            topView.autoSetDimension(.height, toSize: 0.5)

            errorLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            errorLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            errorLabel.autoSetDimension(.height, toSize: 20)

            //---------------------------------------------------------------------------

            nameView.autoPinEdge(.top, to: .bottom, of: errorLabel, withOffset: 10)
            nameView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            nameView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            nameView.autoSetDimension(.height, toSize: fieldSize)

            nameField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            nameField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            nameField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            nameField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

            nameAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            nameAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            nameAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            nameAbstract.autoSetDimension(.width, toSize: 25)

            userImgView.autoPinEdge(toSuperviewEdge: .top, withInset: fieldAlign)
            userImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            userImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))

            nameBorder.autoPinEdge(toSuperviewEdge: .left)
            nameBorder.autoPinEdge(toSuperviewEdge: .right)
            nameBorder.autoPinEdge(toSuperviewEdge: .bottom)
            nameBorder.autoSetDimension(.height, toSize: 0.7)

            //---------------------------------------------------------------------------

            mailView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            mailView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            mailView.autoPinEdge(.top, to: .bottom, of: nameView, withOffset: 10)
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

            phoneView.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            phoneView.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            phoneView.autoPinEdge(.top, to: .bottom, of: mailView, withOffset: 10)
            phoneView.autoSetDimension(.height, toSize: fieldSize)

            phoneField.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            phoneField.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            phoneField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            phoneField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)

            phoneAbstract.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            phoneAbstract.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            phoneAbstract.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            phoneAbstract.autoSetDimension(.width, toSize: 25)

            phoneImgView.autoPinEdge(toSuperviewEdge: .top, withInset: fieldAlign)
            phoneImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 1)
            phoneImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))

            phoneBorder.autoPinEdge(toSuperviewEdge: .left)
            phoneBorder.autoPinEdge(toSuperviewEdge: .right)
            phoneBorder.autoPinEdge(toSuperviewEdge: .bottom)
            phoneBorder.autoSetDimension(.height, toSize: 0.7)

            //---------------------------------------------------------------------------

            changePasswordButton.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            changePasswordButton.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            changePasswordButton.autoPinEdge(.top, to: .bottom, of: phoneView, withOffset: 30)
            changePasswordButton.autoSetDimension(.height, toSize: buttonSize)
        }
    }
}
