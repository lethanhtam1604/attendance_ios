//
//  TrainingDetailTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class TrainingDetailTableViewCell: UITableViewCell {

    let iconImgView = UIImageView()
    let employeeIDLabel = UILabel()
    let nameLabel = UILabel()
    let lineView = UIView()
    let dobLabel = UILabel()
    let genderLabel = UILabel()

    var constraintAdded = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = UIColor.white

        lineView.isHidden = true

        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFill
        iconImgView.image = UIImage(named: "ic_user")
        iconImgView.layer.cornerRadius = 40
        iconImgView.backgroundColor = Global.colorGray
        iconImgView.sd_setShowActivityIndicatorView(true)
        iconImgView.sd_setIndicatorStyle(.gray)

        employeeIDLabel.font = UIFont(name: "OpenSans-bold", size: 18)
        employeeIDLabel.textAlignment = .left
        employeeIDLabel.textColor = Global.colorMain
        employeeIDLabel.lineBreakMode = .byWordWrapping
        employeeIDLabel.numberOfLines = 0

        nameLabel.font = UIFont(name: "OpenSans", size: 16)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0

        dobLabel.font = UIFont(name: "OpenSans", size: 16)
        dobLabel.textAlignment = .left
        dobLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        dobLabel.lineBreakMode = .byWordWrapping
        dobLabel.numberOfLines = 0

        genderLabel.font = UIFont(name: "OpenSans", size: 16)
        genderLabel.textAlignment = .left
        genderLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        genderLabel.lineBreakMode = .byWordWrapping
        genderLabel.numberOfLines = 0

        addSubview(iconImgView)
        addSubview(employeeIDLabel)
        addSubview(nameLabel)
        addSubview(lineView)
        addSubview(dobLabel)
        addSubview(genderLabel)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true

            iconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            iconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            iconImgView.autoSetDimensions(to: CGSize(width: 80, height: 80))

            employeeIDLabel.autoPinEdge(.left, to: .right, of: iconImgView, withOffset: 10)
            employeeIDLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            employeeIDLabel.autoPinEdge(.bottom, to: .top, of: nameLabel, withOffset: -4)

            nameLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            nameLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)
            nameLabel.autoPinEdge(.bottom, to: .top, of: lineView, withOffset: -1)

            lineView.autoPinEdge(toSuperviewEdge: .left)
            lineView.autoAlignAxis(toSuperviewAxis: .horizontal)
            lineView.autoPinEdge(toSuperviewEdge: .right)
            lineView.autoSetDimension(.height, toSize: 2)

            dobLabel.autoPinEdge(.top, to: .bottom, of: lineView, withOffset: 1)
            dobLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            dobLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)

            genderLabel.autoPinEdge(.top, to: .bottom, of: dobLabel, withOffset: 4)
            genderLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            genderLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)
        }
    }

    func bindingData(employee: Employee) {
        employeeIDLabel.text = employee.employeeID
        nameLabel.text = employee.name
        dobLabel.text = employee.dob
        genderLabel.text = employee.gender

        if let url = employee.avatarUrl {
            if url != "" {
                iconImgView.sd_setImage(with: URL(string: url))
            }
            else {
                iconImgView.image = UIImage(named: "ic_user")
            }
        }
        else {
            iconImgView.image = UIImage(named: "ic_user")
        }
    }
}
