//
//  IntroView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/13/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import EAIntroView

class IntroView: UIView {

    var introView = EAIntroView()
    var introPage1 = ItemIntroView()
    var introPage2 = ItemIntroView()
    var introPage3 = ItemIntroView()
    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorMain

        let page1 = EAIntroPage(customView: ItemIntroView())
        page1?.bgColor = Global.colorBlue
        introPage1 = page1?.customView as! ItemIntroView
        introPage1.iconImgView.image = UIImage(named: "green_notebook")
        introPage1.titleLabel.text = "Ready to rock & roll?"
        introPage1.descriptionLabel.text = "Workly will help you to manage time & attendance of your employees"
        introPage1.signUpButton.isHidden = true
        introPage1.signInButton.isHidden = true

        let page2 = EAIntroPage(customView: ItemIntroView())
        page2?.bgColor = Global.colorYellow
        introPage2 = page2?.customView as! ItemIntroView
        introPage2.iconImgView.image = UIImage(named: "yellow_notebook")
        introPage2.titleLabel.text = "Get ready!"
        introPage2.descriptionLabel.text = "Start your account and add employees/students, positions and departments"
        introPage2.signUpButton.isHidden = true
        introPage2.signInButton.isHidden = true

        let page3 = EAIntroPage(customView: ItemIntroView())
        page3?.bgColor = Global.colorPink
        introPage3 = page3?.customView as! ItemIntroView
        introPage3.iconImgView.image = UIImage(named: "pink_notebook")
        introPage3.titleLabel.text = "Set!"
        introPage3.descriptionLabel.text = "Export and manager data"
        introPage3.signUpButton.isHidden = false
        introPage3.signInButton.isHidden = false

        introView.pages = [page1!, page2!, page3!]
        introView.skipButton.isHidden = true
        introView.pageControlY = 50
        introView.show(in: self, animateDuration: 0.3)
        introView.swipeToExit = false

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            introView.autoPinEdge(toSuperviewEdge: .top)
            introView.autoPinEdge(toSuperviewEdge: .left)
            introView.autoPinEdge(toSuperviewEdge: .right)
            introView.autoPinEdge(toSuperviewEdge: .bottom)
        }
    }
}
