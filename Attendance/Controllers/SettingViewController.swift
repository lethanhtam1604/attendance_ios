//
//  SettingViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/4/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    let settingView = SettingView()

    override func loadView() {
        view = settingView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = Global.colorMain
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        title = "SETTINGS"

        let profileAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToProfileView))
        settingView.profileAbstractView.addGestureRecognizer(profileAbstractViewGesture)

        let trainingAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToTrainingView))
        settingView.trainingAbstractView.addGestureRecognizer(trainingAbstractViewGesture)

        let logoutAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToLogoutView))
        settingView.logoutAbstractView.addGestureRecognizer(logoutAbstractViewGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshView()
    }

    func refreshView() {

        var height: CGFloat = 60

        #if Admin
            height = 180
        #endif

        settingView.containerView.autoSetDimension(.height, toSize: height)
        settingView.scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }

    func actionTapToProfileView() {
        let viewController = ProfileViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func actionTapToTrainingView() {
        let viewController = TrainingViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func actionTapToLogoutView() {
        Utils.showAlertAction(title: "Logout", message: "Are you sure want to logout?", viewController: self, alertDelegate: self)
    }
}

extension SettingViewController: AlertDelegate {
    
    func actionTapToNoButton() {

    }

    func actionTapToYesButton() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let nav = UINavigationController(rootViewController: LoginViewController())
                appDelegate.window?.rootViewController = nav
            }
            catch let error as NSError {
                Utils.showAlertAction(title: "Logout", message: error.localizedDescription, viewController: self, alertDelegate: self)
            }
        }
        else {
            Utils.showAlertAction(title: "Logout", message: "Logout error. Please try again!", viewController: self, alertDelegate: self)
        }
    }
}
