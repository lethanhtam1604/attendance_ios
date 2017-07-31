//
//  MenuTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

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
        iconImgView.image = UIImage(named: "User")

        nameLabel.text = "Contact Us"
        nameLabel.font = UIFont(name: "OpenSans", size: 17)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0

        addSubview(iconImgView)
        addSubview(nameLabel)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true

            iconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
            iconImgView.autoSetDimensions(to: CGSize(width: 20, height: 20))
            iconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            nameLabel.autoPinEdge(.left, to: .right, of: iconImgView, withOffset: 20)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        }
    }

    func bindingData(menu: Menu) {
        iconImgView.image = menu.icon
        nameLabel.text = menu.title
    }
}
