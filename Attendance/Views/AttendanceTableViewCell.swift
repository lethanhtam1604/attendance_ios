//
//  AttendanceTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {

    let dateLabel = UILabel()
    let arrowRightImgView = UIButton()
    let bottomView = UIView()

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
        bottomView.backgroundColor = Global.colorSeparator

        dateLabel.text = "01-07-2017"
        dateLabel.font = UIFont(name: "OpenSans-bold", size: 18)
        dateLabel.textAlignment = .left
        dateLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.numberOfLines = 0

        arrowRightImgView.clipsToBounds = true
        arrowRightImgView.contentMode = .scaleAspectFit
        arrowRightImgView.setImage(UIImage(named: "ArrowRight"), for: .normal)
        
        addSubview(dateLabel)
        addSubview(arrowRightImgView)
        addSubview(bottomView)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintAdded {
            constraintAdded = true

            dateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            dateLabel.autoPinEdge(.right, to: .left, of: arrowRightImgView, withOffset: -10)
            dateLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            dateLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)

            arrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            arrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
            arrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

            bottomView.autoPinEdge(toSuperviewEdge: .left)
            bottomView.autoPinEdge(toSuperviewEdge: .right)
            bottomView.autoPinEdge(toSuperviewEdge: .bottom)
            bottomView.autoSetDimension(.height, toSize: 0.7)
        }
    }

    func bindingDate(attendanceDate: AttendanceDate) {
        dateLabel.text = attendanceDate.date
    }
}
