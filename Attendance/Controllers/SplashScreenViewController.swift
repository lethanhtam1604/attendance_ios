//
//  SplashScreenViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase

class SplashScreenViewController: UIViewController, SWRevealViewControllerDelegate {

    let splashScreenView = SplashScreenView()

    override func loadView() {
        view = splashScreenView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        if UserDefaultManager.getInstance().getIsInitApp() {
            var isCheck = false
            Auth.auth().addStateDidChangeListener() { auth, user in
                if !isCheck {
                    isCheck = true
                    if user != nil {
                        self.navToMainPage()
                    }
                    else {
                        self.navToLogInPage()
                    }
                }
            }
        }
        else {
            navToIntroPage()
        }
    }

    func navToLogInPage() {
        let nav = UINavigationController(rootViewController: LoginViewController())
        present(nav, animated: true, completion: nil)
    }

    func navToMainPage() {
        present(MainViewController(), animated: true, completion: nil)
    }

    func navToIntroPage() {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = IntroViewController()
    }
}
