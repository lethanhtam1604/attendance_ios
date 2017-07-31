//
//  ChosenEmployeeTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class ChosenEmployeeTableViewCell: UITableViewCell {

    let userIconImgView = UIImageView()
    let nameLabel = UILabel()

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

        userIconImgView.clipsToBounds = true
        userIconImgView.contentMode = .scaleAspectFill
        userIconImgView.image = UIImage(named: "ic_group")
        userIconImgView.layer.cornerRadius = 25
        userIconImgView.backgroundColor = Global.colorGray
        userIconImgView.sd_setShowActivityIndicatorView(true)
        userIconImgView.sd_setIndicatorStyle(.gray)

        nameLabel.text = "Citynow Floor-1"
        nameLabel.font = UIFont(name: "OpenSans", size: 18)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0

        addSubview(userIconImgView)
        addSubview(nameLabel)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true

            userIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            userIconImgView.autoSetDimensions(to: CGSize(width: 50, height: 50))
            userIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            nameLabel.autoPinEdge(.left, to: .right, of: userIconImgView, withOffset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        }
    }

    func bindingData(employee: Employee) {
        nameLabel.text = employee.name

        if let url = employee.avatarUrl {
            if url != "" {
                userIconImgView.sd_setImage(with: URL(string: url))
            }
            else {
                userIconImgView.image = UIImage(named: "ic_group")
            }
        }
        else {
            userIconImgView.image = UIImage(named: "ic_group")
        }
    }
}
