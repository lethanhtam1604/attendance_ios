//
//  ExportEmployeeView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class ExportEmployeeView: UIView {

    var constraintsAdded = false

    let startDateView = UIView()
    let startDateLabel = UILabel()

    let startDateValueView = UIView()
    let startDateValueField = UITextField()
    let startDateArrowRightImgView = UIImageView()
    let startDateValueAbstractView = UIView()

    let endDateView = UIView()
    let endDateLabel = UILabel()

    let endDateValueView = UIView()
    let endDateValueField = UITextField()
    let endDateArrowRightImgView = UIImageView()
    let endDateValueAbstractView = UIView()

    let groupView = UIView()
    let groupLabel = UILabel()

    let groupValueView = UIView()
    let groupValueField = UITextField()
    let groupArrowRightImgView = UIImageView()
    let groupValueAbstractView = UIView()

    let employeeView = UIView()
    let employeeLabel = UILabel()

    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorBg
        tintColor = Global.colorMain
        addTapToDismiss()

        startDateView.backgroundColor = UIColor.clear
        startDateValueView.backgroundColor = UIColor.white
        endDateView.backgroundColor = UIColor.clear
        endDateValueView.backgroundColor = UIColor.white
        groupView.backgroundColor = UIColor.clear
        groupValueView.backgroundColor = UIColor.white
        employeeView.backgroundColor = UIColor.clear

        startDateValueAbstractView.backgroundColor = UIColor.clear
        startDateValueAbstractView.touchHighlightingStyle = .lightBackground

        endDateValueAbstractView.backgroundColor = UIColor.clear
        endDateValueAbstractView.touchHighlightingStyle = .lightBackground

        groupValueAbstractView.backgroundColor = UIColor.clear
        groupValueAbstractView.touchHighlightingStyle = .lightBackground

        startDateLabel.text = "START DATE"
        startDateLabel.font = UIFont(name: "OpenSans", size: 15)
        startDateLabel.textAlignment = .left
        startDateLabel.textColor = Global.colorGray
        startDateLabel.numberOfLines = 1

        startDateValueField.textAlignment = .left
        startDateValueField.placeholder = "Enter Start Date"
        startDateValueField.textColor = UIColor.black
        startDateValueField.returnKeyType = .go
        startDateValueField.keyboardType = .namePhonePad
        startDateValueField.inputAccessoryView = UIView()
        startDateValueField.autocorrectionType = .no
        startDateValueField.autocapitalizationType = .none
        startDateValueField.font = UIFont(name: "OpenSans", size: 17)
        startDateValueField.isUserInteractionEnabled = false

        endDateLabel.text = "END DATE"
        endDateLabel.font = UIFont(name: "OpenSans", size: 15)
        endDateLabel.textAlignment = .left
        endDateLabel.textColor = Global.colorGray
        endDateLabel.numberOfLines = 1

        endDateValueField.textAlignment = .left
        endDateValueField.placeholder = "Enter End Date"
        endDateValueField.textColor = UIColor.black
        endDateValueField.returnKeyType = .go
        endDateValueField.keyboardType = .namePhonePad
        endDateValueField.inputAccessoryView = UIView()
        endDateValueField.autocorrectionType = .no
        endDateValueField.autocapitalizationType = .none
        endDateValueField.font = UIFont(name: "OpenSans", size: 17)
        endDateValueField.isUserInteractionEnabled = false

        startDateArrowRightImgView.clipsToBounds = true
        startDateArrowRightImgView.contentMode = .scaleAspectFit
        startDateArrowRightImgView.image = UIImage(named: "ArrowRight")

        endDateArrowRightImgView.clipsToBounds = true
        endDateArrowRightImgView.contentMode = .scaleAspectFit
        endDateArrowRightImgView.image = UIImage(named: "ArrowRight")

        groupLabel.text = "GROUP"
        groupLabel.font = UIFont(name: "OpenSans", size: 15)
        groupLabel.textAlignment = .left
        groupLabel.textColor = Global.colorGray
        groupLabel.numberOfLines = 1

        groupValueField.textAlignment = .left
        groupValueField.placeholder = "Enter Group"
        groupValueField.textColor = UIColor.black
        groupValueField.returnKeyType = .go
        groupValueField.keyboardType = .namePhonePad
        groupValueField.inputAccessoryView = UIView()
        groupValueField.autocorrectionType = .no
        groupValueField.autocapitalizationType = .none
        groupValueField.font = UIFont(name: "OpenSans", size: 17)
        groupValueField.isUserInteractionEnabled = false

        groupArrowRightImgView.clipsToBounds = true
        groupArrowRightImgView.contentMode = .scaleAspectFit
        groupArrowRightImgView.image = UIImage(named: "ArrowRight")

        employeeLabel.text = "STUDENTS"
        employeeLabel.font = UIFont(name: "OpenSans", size: 15)
        employeeLabel.textAlignment = .left
        employeeLabel.textColor = Global.colorGray
        employeeLabel.numberOfLines = 1

        startDateView.addSubview(startDateLabel)
        startDateValueView.addSubview(startDateValueField)
        startDateValueView.addSubview(startDateArrowRightImgView)
        startDateValueView.addSubview(startDateValueAbstractView)

        endDateView.addSubview(endDateLabel)
        endDateValueView.addSubview(endDateArrowRightImgView)
        endDateValueView.addSubview(endDateValueAbstractView)
        endDateValueView.addSubview(endDateValueField)

        groupView.addSubview(groupLabel)
        groupValueView.addSubview(groupArrowRightImgView)
        groupValueView.addSubview(groupValueAbstractView)
        groupValueView.addSubview(groupValueField)

        employeeView.addSubview(employeeLabel)

        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = Global.colorSeparator
        tableView.register(ChosenEmployeeTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg

        addSubview(startDateView)
        addSubview(startDateValueView)
        addSubview(endDateView)
        addSubview(endDateValueView)
        addSubview(groupView)
        addSubview(groupValueView)
        addSubview(employeeView)
        addSubview(tableView)
        addSubview(indicator)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            let height: CGFloat = 50

            //------------------------------------------------------------------------

            startDateView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            startDateView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            startDateView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            startDateView.autoSetDimension(.height, toSize: height)

            startDateLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            startDateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            startDateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            startDateLabel.autoSetDimension(.height, toSize: 20)

            startDateValueView.autoPinEdge(.top, to: .bottom, of: startDateView)
            startDateValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            startDateValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            startDateValueView.autoSetDimension(.height, toSize: height)

            startDateValueField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            startDateValueField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            startDateValueField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            startDateValueField.autoPinEdge(.right, to: .left, of: startDateArrowRightImgView, withOffset: -10)

            startDateArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            startDateArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            startDateArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            startDateValueAbstractView.autoPinEdgesToSuperviewEdges()

            //------------------------------------------------------------------------

            endDateView.autoPinEdge(.top, to: .bottom, of: startDateValueField)
            endDateView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            endDateView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            endDateView.autoSetDimension(.height, toSize: height)

            endDateLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            endDateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            endDateLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            endDateLabel.autoSetDimension(.height, toSize: 20)

            endDateValueView.autoPinEdge(.top, to: .bottom, of: endDateView)
            endDateValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            endDateValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            endDateValueView.autoSetDimension(.height, toSize: height)

            endDateValueField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            endDateValueField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            endDateValueField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            endDateValueField.autoPinEdge(.right, to: .left, of: endDateArrowRightImgView, withOffset: -10)

            endDateArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            endDateArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            endDateArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            endDateValueAbstractView.autoPinEdgesToSuperviewEdges()

            //------------------------------------------------------------------------

            groupView.autoPinEdge(.top, to: .bottom, of: endDateValueField)
            groupView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            groupView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            groupView.autoSetDimension(.height, toSize: height)

            groupLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            groupLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            groupLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            groupLabel.autoSetDimension(.height, toSize: 20)

            groupValueView.autoPinEdge(.top, to: .bottom, of: groupView)
            groupValueView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            groupValueView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            groupValueView.autoSetDimension(.height, toSize: height)

            groupValueField.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
            groupValueField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
            groupValueField.autoPinEdge(toSuperviewEdge: .left, withInset: 24)
            groupValueField.autoPinEdge(.right, to: .left, of: groupArrowRightImgView, withOffset: -10)

            groupArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            groupArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            groupArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            groupValueAbstractView.autoPinEdgesToSuperviewEdges()

            //------------------------------------------------------------------------

            employeeView.autoPinEdge(.top, to: .bottom, of: groupValueField)
            employeeView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            employeeView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            employeeView.autoSetDimension(.height, toSize: height)

            employeeLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 18)
            employeeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            employeeLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
            employeeLabel.autoSetDimension(.height, toSize: 20)

            //------------------------------------------------------------------------

            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoMatch(.width, to: .width, of: self)
            tableView.autoPinEdge(.top, to: .bottom, of: employeeView)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)

            indicator.autoAlignAxis(toSuperviewAxis: .vertical)
            indicator.autoMatch(.width, to: .width, of: self)
            indicator.autoPinEdge(.top, to: .bottom, of: endDateValueField)
            indicator.autoPinEdge(toSuperviewMargin: .bottom)
        }
    }
}
