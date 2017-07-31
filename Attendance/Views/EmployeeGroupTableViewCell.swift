//
//  EmployeeGroupTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import SDWebImage

class EmployeeGroupTableViewCell: UITableViewCell {

    let containerView = UIView()
    let userIconImgView = UIImageView()
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

        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.setImage(UIImage(named: "ArrowRight"), for: .normal)

        containerView.addSubview(userIconImgView)
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

            userIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            userIconImgView.autoSetDimensions(to: CGSize(width: 50, height: 50))
            userIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            nameLabel.autoPinEdge(.left, to: .right, of: userIconImgView, withOffset: 10)
            nameLabel.autoPinEdge(.right, to: .left, of: arrowRightImgView, withOffset: -10)
            nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)

            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            arrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }

    func bindingData(group: Group) {
        nameLabel.text = group.name

        if let url = group.imageUrl {
            if url != "" {
                userIconImgView.sd_setImage(with: URL(string: url), completed: { (image, error, cacheType, url) in
                    self.userIconImgView.image = image?.resizeImage(scale: 0.5)
                })
            }
            else {
                userIconImgView.image = UIImage(named: "ic_group")
            }
        }
        else {
            userIconImgView.image = UIImage(named: "ic_group")
        }


        DispatchQueue.main.async {
            self.containerView.layer.shadowPath = UIBezierPath(rect: self.containerView.bounds).cgPath
        }
    }
}
