//
//  EmployeHeaderView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/19/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DropDown

class EmployeHeaderView: UICollectionReusableView {

    let avatarButton = UIButton()

    let idView = UIView()
    let idLabel = UILabel()
    let idValueView = UIView()
    let idField = UITextField()

    let nameView = UIView()
    let nameLabel = UILabel()
    let nameValueView = UIView()
    let nameField = UITextField()

    let dobView = UIView()
    let dobLabel = UILabel()
    let dobValueView = UIView()
    let dobField = UITextField()

    let dobArrowDropDownView = UIView()
    let dobArrowDropDownImgView = UIImageView()
    let dobAbstract = UIView()

    let genderView = UIView()
    let genderLabel = UILabel()
    let genderValueView = UIView()
    let genderField = UITextField()

    let genderArrowDropDownView = UIView()
    let genderArrowDropDownImgView = UIImageView()
    let genderAbstract = UIView()
    let genderDropDown = DropDown()

    let photoView = UIView()
    let photoLabel = UILabel()
    let addBtn = UIButton(type: .custom)

    var constraintAdded = false

    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        backgroundColor = UIColor.clear
        tintColor = Global.colorMain

        avatarButton.setImage(UIImage(named: "ic_user"), for: .normal)
        avatarButton.layer.cornerRadius = 5
        avatarButton.clipsToBounds = true
        avatarButton.imageView?.clipsToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.sd_setShowActivityIndicatorView(true)
        avatarButton.sd_setIndicatorStyle(.gray)
        avatarButton.backgroundColor = Global.colorGray

        idView.backgroundColor = UIColor.clear
        idValueView.backgroundColor = UIColor.white

        idLabel.text = "STUDENT ID"
        idLabel.font = UIFont(name: "OpenSans", size: 15)
        idLabel.textAlignment = .left
        idLabel.textColor = Global.colorGray
        idLabel.numberOfLines = 1

        idField.textAlignment = .left
        idField.placeholder = "Enter Student ID"
        idField.textColor = UIColor.black
        idField.returnKeyType = .next
        idField.keyboardType = .namePhonePad
        idField.inputAccessoryView = UIView()
        idField.autocorrectionType = .no
        idField.autocapitalizationType = .none
        idField.font = UIFont(name: "OpenSans-semibold", size: 17)

        nameView.backgroundColor = UIColor.clear
        nameValueView.backgroundColor = UIColor.white

        nameLabel.text = "STUDENT NAME"
        nameLabel.font = UIFont(name: "OpenSans", size: 15)
        nameLabel.textAlignment = .left
        nameLabel.textColor = Global.colorGray
        nameLabel.numberOfLines = 1

        nameField.textAlignment = .left
        nameField.placeholder = "Enter Student Name"
        nameField.textColor = UIColor.black
        nameField.returnKeyType = .next
        nameField.keyboardType = .namePhonePad
        nameField.inputAccessoryView = UIView()
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .none
        nameField.font = UIFont(name: "OpenSans-semibold", size: 17)
        nameField.backgroundColor = UIColor.white

        dobArrowDropDownView.backgroundColor = UIColor.white
        dobArrowDropDownView.addSubview(dobArrowDropDownImgView)

        dobArrowDropDownImgView.clipsToBounds = true
        dobArrowDropDownImgView.contentMode = .scaleAspectFit
        dobArrowDropDownImgView.image = UIImage(named: "ic_arrow_drop_down")

        dobView.backgroundColor = UIColor.clear
        dobValueView.backgroundColor = UIColor.white

        dobLabel.text = "DOB"
        dobLabel.font = UIFont(name: "OpenSans", size: 15)
        dobLabel.textAlignment = .left
        dobLabel.textColor = Global.colorGray
        dobLabel.numberOfLines = 1

        dobField.textAlignment = .left
        dobField.placeholder = "Enter DOB"
        dobField.textColor = UIColor.black
        dobField.returnKeyType = .next
        dobField.keyboardType = .phonePad
        dobField.inputAccessoryView = UIView()
        dobField.autocorrectionType = .no
        dobField.autocapitalizationType = .none
        dobField.font = UIFont(name: "OpenSans", size: 17)

        dobAbstract.backgroundColor = UIColor.clear
        dobArrowDropDownView.backgroundColor = UIColor.white
        dobArrowDropDownView.addSubview(dobArrowDropDownImgView)
        dobField.addSubview(dobArrowDropDownView)
        dobField.addSubview(dobAbstract)

        genderArrowDropDownView.backgroundColor = UIColor.white
        genderArrowDropDownView.addSubview(genderArrowDropDownImgView)

        genderArrowDropDownImgView.clipsToBounds = true
        genderArrowDropDownImgView.contentMode = .scaleAspectFit
        genderArrowDropDownImgView.image = UIImage(named: "ic_arrow_drop_down")

        genderView.backgroundColor = UIColor.clear
        genderValueView.backgroundColor = UIColor.white

        genderLabel.text = "GENDER"
        genderLabel.font = UIFont(name: "OpenSans", size: 15)
        genderLabel.textAlignment = .left
        genderLabel.textColor = Global.colorGray
        genderLabel.numberOfLines = 1

        genderField.textAlignment = .left
        genderField.placeholder = "Enter GENDER"
        genderField.textColor = UIColor.black
        genderField.returnKeyType = .next
        genderField.keyboardType = .phonePad
        genderField.inputAccessoryView = UIView()
        genderField.autocorrectionType = .no
        genderField.autocapitalizationType = .none
        genderField.font = UIFont(name: "OpenSans", size: 17)

        genderAbstract.backgroundColor = UIColor.clear
        genderField.addSubview(genderArrowDropDownView)
        genderField.addSubview(genderAbstract)

        genderDropDown.anchorView = genderField
        genderDropDown.direction = .bottom
        genderDropDown.bottomOffset = CGPoint(x: 0, y: 1)
        genderDropDown.selectionAction = { [unowned self] (index, item) in
            self.genderField.text = item
        }

        photoView.backgroundColor = UIColor.clear

        photoLabel.text = "PHOTOS"
        photoLabel.font = UIFont(name: "OpenSans", size: 15)
        photoLabel.textAlignment = .left
        photoLabel.textColor = Global.colorGray
        photoLabel.numberOfLines = 1

        addBtn.backgroundColor = UIColor.clear
        addBtn.clipsToBounds = true
        addBtn.contentMode = .scaleAspectFit
        let tintedImage = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        addBtn.setImage(tintedImage, for: .normal)
        addBtn.setImage(UIImage(named: "add"), for: .highlighted)
        addBtn.tintColor = Global.colorMain

        photoView.addSubview(photoLabel)
        photoView.addSubview(addBtn)

        idView.addSubview(idLabel)
        idValueView.addSubview(idField)

        nameView.addSubview(nameLabel)
        nameValueView.addSubview(nameField)

        dobView.addSubview(dobLabel)
        dobValueView.addSubview(dobField)

        genderView.addSubview(genderLabel)
        genderValueView.addSubview(genderField)

        addSubview(avatarButton)
        addSubview(idView)
        addSubview(idValueView)
        addSubview(nameView)
        addSubview(nameValueView)
        addSubview(dobView)
        addSubview(dobValueView)
        addSubview(genderView)
        addSubview(genderValueView)
        addSubview(photoView)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true

            let height: CGFloat = 50

            avatarButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            avatarButton.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            avatarButton.autoSetDimensions(to: CGSize(width: 90, height: 90))

            //------------------------------------------------------------------------

            idView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            idView.autoPinEdge(.left, to: .right, of: avatarButton, withOffset: 10)
            idView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            idView.autoSetDimension(.height, toSize: height)

            idLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            idLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            idLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            idLabel.autoSetDimension(.height, toSize: 20)

            //------------------------------------------------------------------------

            idValueView.autoPinEdge(.top, to: .bottom, of: idView)
            idValueView.autoPinEdge(toSuperviewEdge: .right)
            idValueView.autoPinEdge(.left, to: .left, of: idView)
            idValueView.autoSetDimension(.height, toSize: height)

            idField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            idField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            idField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            idField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)

            //------------------------------------------------------------------------

            nameView.autoPinEdge(.top, to: .bottom, of: idValueView, withOffset: 0)
            nameView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            nameView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            nameView.autoSetDimension(.height, toSize: height)

            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            nameLabel.autoSetDimension(.height, toSize: 20)

            //------------------------------------------------------------------------

            nameValueView.autoPinEdge(.top, to: .bottom, of: nameView)
            nameValueView.autoPinEdge(toSuperviewEdge: .right)
            nameValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            nameValueView.autoSetDimension(.height, toSize: height)

            nameField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            nameField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            nameField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            nameField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)

            //------------------------------------------------------------------------

            dobView.autoPinEdge(.top, to: .bottom, of: nameValueView, withOffset: 0)
            dobView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            dobView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            dobView.autoSetDimension(.height, toSize: height)

            dobLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            dobLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            dobLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            dobLabel.autoSetDimension(.height, toSize: 20)

            //------------------------------------------------------------------------

            dobValueView.autoPinEdge(.top, to: .bottom, of: dobView)
            dobValueView.autoPinEdge(toSuperviewEdge: .right)
            dobValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            dobValueView.autoSetDimension(.height, toSize: height)

            dobField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            dobField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            dobField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            dobField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)

            //------------------------------------------------------------------------

            dobArrowDropDownView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            dobArrowDropDownView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            dobArrowDropDownView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            dobArrowDropDownView.autoSetDimension(.width, toSize: 25)

            dobArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            dobArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 1)
            dobArrowDropDownImgView.autoSetDimensions(to: CGSize(width: 25, height: 25))

            dobAbstract.autoPinEdgesToSuperviewEdges()

            //------------------------------------------------------------------------

            genderView.autoPinEdge(.top, to: .bottom, of: dobValueView, withOffset: 0)
            genderView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            genderView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            genderView.autoSetDimension(.height, toSize: height)

            genderLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            genderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            genderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            genderLabel.autoSetDimension(.height, toSize: 20)

            //------------------------------------------------------------------------

            genderValueView.autoPinEdge(.top, to: .bottom, of: genderView)
            genderValueView.autoPinEdge(toSuperviewEdge: .right)
            genderValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            genderValueView.autoSetDimension(.height, toSize: height)

            genderField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            genderField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            genderField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            genderField.autoPinEdge(toSuperviewEdge: .right, withInset: 5)

            //------------------------------------------------------------------------

            genderArrowDropDownView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            genderArrowDropDownView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            genderArrowDropDownView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 1)
            genderArrowDropDownView.autoSetDimension(.width, toSize: 25)

            genderArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
            genderArrowDropDownImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 1)
            genderArrowDropDownImgView.autoSetDimensions(to: CGSize(width: 25, height: 25))

            genderAbstract.autoPinEdgesToSuperviewEdges()

            //------------------------------------------------------------------------

            photoView.autoPinEdge(.top, to: .bottom, of: genderValueView)
            photoView.autoPinEdge(toSuperviewEdge: .right)
            photoView.autoPinEdge(toSuperviewEdge: .left)
            photoView.autoSetDimension(.height, toSize: height)

            photoLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            photoLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            photoLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            photoLabel.autoPinEdge(.right, to: .left, of: addBtn, withOffset: 10)

            addBtn.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            addBtn.autoSetDimensions(to: CGSize(width: 50, height: 50))
            addBtn.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }

}
