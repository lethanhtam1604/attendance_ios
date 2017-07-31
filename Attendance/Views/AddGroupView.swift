//
//  AddGroupView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import SDWebImage

class AddGroupView: UIView {

    let scrollView = UIScrollView()
    let containerView = UIView()

    var constraintsAdded = false

    let avatarButton = UIButton()

    let nameField = UITextField()
    let nameBorder = UIView()

    let cancelBtn = UIButton()
    let addBtn = UIButton()

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor.white
        tintColor = Global.colorMain
        addTapToDismiss()

        avatarButton.setImage(UIImage(named: "Teamwork-Icon"), for: .normal)
        avatarButton.layer.cornerRadius = 40
        avatarButton.clipsToBounds = true
        avatarButton.imageView?.clipsToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.sd_setShowActivityIndicatorView(true)
        avatarButton.sd_setIndicatorStyle(.gray)
        avatarButton.backgroundColor = Global.colorGray

        nameField.textAlignment = .left
        nameField.placeholder = "Name*"
        nameField.textColor = UIColor.black
        nameField.returnKeyType = .done
        nameField.keyboardType = .namePhonePad
        nameField.inputAccessoryView = UIView()
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .none
        nameField.font = UIFont(name: "OpenSans", size: 17)
        nameBorder.backgroundColor = Global.colorSeparator
        nameField.addSubview(nameBorder)

        cancelBtn.setTitle("CANCEL", for: .normal)
        cancelBtn.backgroundColor = Global.colorMain
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        cancelBtn.clipsToBounds = true
        cancelBtn.titleLabel?.lineBreakMode = .byWordWrapping
        cancelBtn.titleLabel?.textAlignment = .center

        addBtn.setTitle("ADD", for: .normal)
        addBtn.backgroundColor = Global.colorMain
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.setTitleColor(Global.colorSelected, for: .highlighted)
        addBtn.layer.cornerRadius = 5
        addBtn.titleLabel?.font = UIFont(name: "OpenSans-semibold", size: 15)
        addBtn.clipsToBounds = true
        addBtn.titleLabel?.lineBreakMode = .byWordWrapping
        addBtn.titleLabel?.textAlignment = .center

        containerView.addSubview(avatarButton)
        containerView.addSubview(nameField)
        containerView.addSubview(addBtn)
        containerView.addSubview(cancelBtn)

        scrollView.addSubview(containerView)
        addSubview(scrollView)
        addSubview(cancelBtn)
        addSubview(addBtn)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            scrollView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            scrollView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            scrollView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            scrollView.autoPinEdge(.bottom, to: .top, of: cancelBtn, withOffset: -10)

            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: self)

            let alpha: CGFloat = 20

            avatarButton.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
            avatarButton.autoAlignAxis(toSuperviewAxis: .vertical)
            avatarButton.autoSetDimensions(to: CGSize(width: 80, height: 80))

            nameField.autoPinEdge(.top, to: .bottom, of: avatarButton, withOffset: 20)
            nameField.autoPinEdge(toSuperviewEdge: .left, withInset: alpha)
            nameField.autoPinEdge(toSuperviewEdge: .right, withInset: alpha)
            nameField.autoSetDimension(.height, toSize: 40)

            nameBorder.autoPinEdge(toSuperviewEdge: .left)
            nameBorder.autoPinEdge(toSuperviewEdge: .right)
            nameBorder.autoPinEdge(toSuperviewEdge: .bottom)
            nameBorder.autoSetDimension(.height, toSize: 0.7)

            addBtn.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            addBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            addBtn.autoSetDimensions(to: CGSize(width: 80, height: 30))

            cancelBtn.autoPinEdge(.bottom, to: .bottom, of: addBtn)
            cancelBtn.autoMatch(.height, to: .height, of: addBtn)
            cancelBtn.autoMatch(.width, to: .width, of: addBtn)
            cancelBtn.autoPinEdge(.right, to: .left, of: addBtn, withOffset: -10)
        }
    }
}
