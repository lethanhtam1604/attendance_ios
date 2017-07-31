//
//  MenuHeaderView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class MenuHeaderView: UITableViewCell {

    let iconImgView = UIImageView()
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

        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = UIImage(named: "admin")
        iconImgView.layer.borderColor = UIColor.white.cgColor
        iconImgView.layer.borderWidth = 3
        iconImgView.layer.cornerRadius = 40

        nameLabel.font = UIFont(name: "OpenSans-bold", size: 18)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.white
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 2

        contentView.addSubview(iconImgView)
        contentView.addSubview(nameLabel)

        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !constraintAdded {
            constraintAdded = true

            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
            nameLabel.autoSetDimension(.height, toSize: 40)

            iconImgView.autoPinEdge(.bottom, to: .top, of: nameLabel, withOffset: -10)
            iconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            iconImgView.autoSetDimensions(to: CGSize(width: 80, height: 80))
        }
    }

    func bindingData(user: User) {
        nameLabel.text = user.name
    }
}
