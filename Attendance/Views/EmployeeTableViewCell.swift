//
//  EmployeeTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/27/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    let containerView = UIView()
    let iconImgView = UIImageView()
    let nameLabel = UILabel()
    let arrowRightImgView = UIButton()

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
        backgroundColor = UIColor.clear

        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 2
        containerView.layer.masksToBounds = false

        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFill
        iconImgView.layer.cornerRadius = 20
        iconImgView.backgroundColor = Global.colorGray
        iconImgView.sd_setShowActivityIndicatorView(true)
        iconImgView.sd_setIndicatorStyle(.gray)

        nameLabel.font = UIFont(name: "OpenSans", size: 16)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 0

        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.setImage(UIImage(named: "ArrowRight"), for: .normal)

        containerView.addSubview(iconImgView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(arrowRightImgView)

        addSubview(containerView)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true

            containerView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            containerView.autoPinEdge(toSuperviewEdge: .left, withInset: 12)
            containerView.autoPinEdge(toSuperviewEdge: .right, withInset: 12)
            containerView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 2)

            iconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
            iconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            iconImgView.autoSetDimensions(to: CGSize(width: 40, height: 40))

            nameLabel.autoPinEdge(.left, to: .right, of: iconImgView, withOffset: 10)
            nameLabel.autoPinEdge(.right, to: .left, of: arrowRightImgView, withOffset: -10)
            nameLabel.autoAlignAxis(toSuperviewAxis: .horizontal)

            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            arrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }

    func bindingData(employee: Employee) {
        nameLabel.text = employee.name

        if let url = employee.avatarUrl {
            if url != "" {
                iconImgView.sd_setImage(with: URL(string: url), completed: { (image, error, cacheType, url) in
                    self.iconImgView.image = image?.resizeImage(scale: 0.5)
                })
            }
            else {
                iconImgView.image = UIImage(named: "ic_user")
            }
        }
        else {
            iconImgView.image = UIImage(named: "ic_user")
        }

        DispatchQueue.main.async {
            self.containerView.layer.shadowPath = UIBezierPath(rect: self.containerView.bounds).cgPath
        }
    }
}
