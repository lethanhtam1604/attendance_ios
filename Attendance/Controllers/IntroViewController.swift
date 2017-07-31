//
//  IntroViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/13/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import EAIntroView

class IntroViewController: UIViewController {

    let introMainView = IntroView()

    override func loadView() {
        view = introMainView
        view.setNeedsUpdateConstraints()

        introMainView.introView.delegate = self

        introMainView.introPage3.signInButton.addTarget(self, action: #selector(actionTapToSignInButton), for: .touchUpInside)
        introMainView.introPage3.signUpButton.addTarget(self, action: #selector(actionTapToSignUpButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func actionTapToSignInButton() {
        let nav = UINavigationController(rootViewController: LoginViewController())
        present(nav, animated: true, completion: nil)
    }

    func actionTapToSignUpButton() {
        let nav = UINavigationController(rootViewController: RegisterViewController())
        present(nav, animated: true, completion: nil)
    }
}

extension IntroViewController: EAIntroDelegate {

}
