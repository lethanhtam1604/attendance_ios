//
//  EmployeeGroupCollectionViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/13/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class EmployeeGroupCollectionViewCell: UICollectionViewCell {

    let userIconImgView = UIImageView()
    let nameLabel = UILabel()

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
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath

        userIconImgView.clipsToBounds = true
        userIconImgView.contentMode = .scaleAspectFill
        userIconImgView.layer.cornerRadius = 40
        userIconImgView.backgroundColor = Global.colorGray
        userIconImgView.sd_setShowActivityIndicatorView(true)
        userIconImgView.sd_setIndicatorStyle(.gray)

        nameLabel.text = "Citynow Floor-1"
        nameLabel.font = UIFont(name: "OpenSans", size: 16)
        nameLabel.textAlignment = .center
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

            userIconImgView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            userIconImgView.autoSetDimensions(to: CGSize(width: 80, height: 80))
            userIconImgView.autoAlignAxis(toSuperviewAxis: .vertical)

            nameLabel.autoPinEdge(.top, to: .bottom, of: userIconImgView, withOffset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            nameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
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
    }
}
