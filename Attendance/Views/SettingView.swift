//
//  SettingView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/5/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class SettingView: UIView {

    let scrollView = UIScrollView()
    let containerView = UIView()

    let profileView = UIView()
    let profileIconImgView = UIImageView()
    let profileLabel = UILabel()
    let profileArrowRightImgView = UIImageView()
    let profileAbstractView = UIView()
    let profileBorderView = UIView()

    let trainingView = UIView()
    let trainingIconImgView = UIImageView()
    let trainingLabel = UILabel()
    let trainingArrowRightImgView = UIImageView()
    let trainingAbstractView = UIView()
    let trainingBorderView = UIView()

    let logoutView = UIView()
    let logoutIconImgView = UIImageView()
    let logoutLabel = UILabel()
    let logoutAbstractView = UIView()

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor.white

        backgroundColor = Global.colorBg
        tintColor = Global.colorMain
        addTapToDismiss()

        profileView.backgroundColor = UIColor.white
        trainingView.backgroundColor = UIColor.white
        logoutView.backgroundColor = UIColor.white

        profileAbstractView.backgroundColor = UIColor.clear
        profileAbstractView.touchHighlightingStyle = .lightBackground

        trainingAbstractView.backgroundColor = UIColor.clear
        trainingAbstractView.touchHighlightingStyle = .lightBackground

        logoutAbstractView.backgroundColor = UIColor.clear
        logoutAbstractView.touchHighlightingStyle = .lightBackground

        profileLabel.text = "Profile"
        profileLabel.font = UIFont(name: "OpenSans-semibold", size: 17)
        profileLabel.textAlignment = .left
        profileLabel.textColor = UIColor.black
        profileLabel.numberOfLines = 1

        profileArrowRightImgView.clipsToBounds = true
        profileArrowRightImgView.contentMode = .scaleAspectFit
        profileArrowRightImgView.image = UIImage(named: "ArrowRight")

        profileIconImgView.clipsToBounds = true
        profileIconImgView.contentMode = .scaleAspectFit
        profileIconImgView.image = UIImage(named: "User")

        profileBorderView.backgroundColor = Global.colorSeparator

        trainingLabel.text = "Training"
        trainingLabel.font = UIFont(name: "OpenSans-semibold", size: 17)
        trainingLabel.textAlignment = .left
        trainingLabel.textColor = UIColor.black
        trainingLabel.numberOfLines = 1

        trainingArrowRightImgView.clipsToBounds = true
        trainingArrowRightImgView.contentMode = .scaleAspectFit
        trainingArrowRightImgView.image = UIImage(named: "ArrowRight")

        trainingIconImgView.clipsToBounds = true
        trainingIconImgView.contentMode = .scaleAspectFit
        trainingIconImgView.image = UIImage(named: "Business")

        trainingBorderView.backgroundColor = Global.colorSeparator

        logoutLabel.text = "Logout"
        logoutLabel.font = UIFont(name: "OpenSans-semibold", size: 17)
        logoutLabel.textAlignment = .left
        logoutLabel.textColor = Global.colorMain
        logoutLabel.numberOfLines = 1

        logoutIconImgView.clipsToBounds = true
        logoutIconImgView.contentMode = .scaleAspectFit
        logoutIconImgView.image = UIImage(named: "Logout")

        profileView.addSubview(profileLabel)
        profileView.addSubview(profileArrowRightImgView)
        profileView.addSubview(profileIconImgView)
        profileView.addSubview(profileAbstractView)
        profileView.addSubview(profileBorderView)

        trainingView.addSubview(trainingLabel)
        trainingView.addSubview(trainingArrowRightImgView)
        trainingView.addSubview(trainingIconImgView)
        trainingView.addSubview(trainingAbstractView)
        trainingView.addSubview(trainingBorderView)

        logoutView.addSubview(logoutLabel)
        logoutView.addSubview(logoutIconImgView)
        logoutView.addSubview(logoutAbstractView)

        #if Admin
            containerView.addSubview(profileView)
            containerView.addSubview(trainingView)
        #endif

        containerView.addSubview(logoutView)

        scrollView.addSubview(containerView)
        addSubview(scrollView)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            scrollView.autoPinEdgesToSuperviewEdges()

            containerView.autoPinEdgesToSuperviewEdges()
            containerView.autoMatch(.width, to: .width, of: self)

            let height: CGFloat = 60

            //------------------------------------------------------------------------

            #if Admin

                profileView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
                profileView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
                profileView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
                profileView.autoSetDimension(.height, toSize: height)

                profileIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
                profileIconImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
                profileIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

                profileLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
                profileLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
                profileLabel.autoPinEdge(.left, to: .right, of: profileIconImgView, withOffset: 10)
                profileLabel.autoPinEdge(.right, to: .left, of: profileArrowRightImgView, withOffset: -10)

                profileArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
                profileArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
                profileArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

                profileBorderView.autoPinEdge(toSuperviewEdge: .bottom)
                profileBorderView.autoPinEdge(toSuperviewEdge: .right)
                profileBorderView.autoPinEdge(toSuperviewEdge: .left)
                profileBorderView.autoSetDimension(.height, toSize: 0.5)

                profileAbstractView.autoPinEdgesToSuperviewEdges()

                //------------------------------------------------------------------------

                trainingView.autoPinEdge(.top, to: .bottom, of: profileView, withOffset: 0)
                trainingView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
                trainingView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
                trainingView.autoSetDimension(.height, toSize: height)

                trainingIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
                trainingIconImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
                trainingIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

                trainingLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
                trainingLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
                trainingLabel.autoPinEdge(.left, to: .right, of: trainingIconImgView, withOffset: 10)
                trainingLabel.autoPinEdge(.right, to: .left, of: trainingArrowRightImgView, withOffset: -10)

                trainingArrowRightImgView.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
                trainingArrowRightImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
                trainingArrowRightImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

                trainingBorderView.autoPinEdge(toSuperviewEdge: .bottom)
                trainingBorderView.autoPinEdge(toSuperviewEdge: .right)
                trainingBorderView.autoPinEdge(toSuperviewEdge: .left)
                trainingBorderView.autoSetDimension(.height, toSize: 0.5)

                trainingAbstractView.autoPinEdgesToSuperviewEdges()

                //------------------------------------------------------------------------

                logoutView.autoPinEdge(.top, to: .bottom, of: trainingView, withOffset: 0)
                logoutView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
                logoutView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
                logoutView.autoSetDimension(.height, toSize: height)

                logoutIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
                logoutIconImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
                logoutIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)

                logoutLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
                logoutLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
                logoutLabel.autoPinEdge(.left, to: .right, of: logoutIconImgView, withOffset: 10)
                logoutLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)

                logoutAbstractView.autoPinEdgesToSuperviewEdges()

            #else

                logoutView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
                logoutView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
                logoutView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
                logoutView.autoSetDimension(.height, toSize: height)
                
                logoutIconImgView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
                logoutIconImgView.autoSetDimensions(to: CGSize(width: 15, height: 15))
                logoutIconImgView.autoAlignAxis(toSuperviewAxis: .horizontal)
                
                logoutLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
                logoutLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
                logoutLabel.autoPinEdge(.left, to: .right, of: logoutIconImgView, withOffset: 10)
                logoutLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)

                logoutAbstractView.autoPinEdgesToSuperviewEdges()
            #endif
        }
    }
}
