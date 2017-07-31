//
//  AttendanceDetailTableViewCell.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import SDWebImage

class AttendanceDetailTableViewCell: UITableViewCell {

    let containerView = UIView()
    let iconImgView = UIImageView()
    let employeeIDLabel = UILabel()
    let nameLabel = UILabel()
    let lineView = UIView()
    let checkInTimeLabel = UILabel()
    let checkOutTimeLabel = UILabel()

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

        checkInTimeLabel.font = UIFont(name: "OpenSans", size: 16)
        checkInTimeLabel.textAlignment = .left
        checkInTimeLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        checkInTimeLabel.lineBreakMode = .byWordWrapping
        checkInTimeLabel.numberOfLines = 0

        checkOutTimeLabel.font = UIFont(name: "OpenSans", size: 16)
        checkOutTimeLabel.textAlignment = .left
        checkOutTimeLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        checkOutTimeLabel.lineBreakMode = .byWordWrapping
        checkOutTimeLabel.numberOfLines = 0

        containerView.addSubview(iconImgView)
        containerView.addSubview(employeeIDLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(checkInTimeLabel)
        containerView.addSubview(checkOutTimeLabel)

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

            checkInTimeLabel.autoPinEdge(.top, to: .bottom, of: lineView, withOffset: 1)
            checkInTimeLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            checkInTimeLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)

            checkOutTimeLabel.autoPinEdge(.top, to: .bottom, of: checkInTimeLabel, withOffset: 4)
            checkOutTimeLabel.autoPinEdge(.left, to: .left, of: employeeIDLabel)
            checkOutTimeLabel.autoPinEdge(.right, to: .right, of: employeeIDLabel)
        }
    }

    func bindingData(groupId: String, attendance: Attendance) {

        DatabaseHelper.shared.getEmployee(id: attendance.employeeId) { newEmployee in

            if let employee = newEmployee {
                attendance.employee = employee

                self.employeeIDLabel.text = employee.employeeID
                self.nameLabel.text = employee.name

                let checkInTime = "Check-in Time: "
                var checkInTimeValue = ""

                if attendance.attendanceTimes.count > 0 {
                    checkInTimeValue = attendance.attendanceTimes[0].time ?? ""
                }

                let checkOutTime = "Check-out Time: "
                var checkOutTimeValue = ""

                if attendance.attendanceTimes.count > 1 {
                    checkOutTimeValue = attendance.attendanceTimes[attendance.attendanceTimes.count - 1].time ?? ""
                }

                let checkInStr = "\(checkInTime) \(checkInTimeValue)"
                let checkInAttributedString = NSMutableAttributedString(string: checkInStr)
                checkInAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: (checkInStr as NSString).range(of: checkInTime))
                self.checkInTimeLabel.attributedText = checkInAttributedString

                let checkOutStr = "\(checkOutTime) \(checkOutTimeValue)"
                let checkOutAttributedString = NSMutableAttributedString(string: checkOutStr)
                checkOutAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: (checkOutStr as NSString).range(of: checkOutTime))
                self.checkOutTimeLabel.attributedText = checkOutAttributedString

                if let url = employee.avatarUrl {
                    if url != "" {
                        self.iconImgView.sd_setImage(with: URL(string: url), completed: { (image, error, cacheType, url) in
                            self.iconImgView.image = image?.resizeImage(scale: 0.5)
                        })
                    }
                    else {
                        self.iconImgView.image = UIImage(named: "ic_user")
                    }
                }
                else {
                    self.iconImgView.image = UIImage(named: "ic_user")
                }
            }
        }

        DispatchQueue.main.async {
            self.containerView.layer.shadowPath = UIBezierPath(rect: self.containerView.bounds).cgPath
        }
    }
}
