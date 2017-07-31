//
//  LoginViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase
import SwiftOverlays

class LoginViewController: UIViewController {

    let loginView = LoginView()

    override func loadView() {
        view = loginView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        title = "LOGIN"

        loginView.mailField.delegate = self
        loginView.passwordField.delegate = self

        loginView.signInButton.addTarget(self, action: #selector(actionTapToSignInButton), for: .touchUpInside)
        loginView.newUserButton.addTarget(self, action: #selector(actionTapToCreateNewAccountButton), for: .touchUpInside)
        loginView.forgotButton.addTarget(self, action: #selector(actionTapToForgotButton), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var buttonSize: CGFloat = 40
        var fieldSize: CGFloat = 40
        var imageSize: CGFloat = 100

        if DeviceType.IS_IPAD {
            buttonSize = 50
            fieldSize = 50
            imageSize = 200
        }

        let height: CGFloat = 50 + imageSize + 30 + 20 + 20 + fieldSize + 10 + fieldSize + 30 + buttonSize + 10 + 30 + 10 + buttonSize + 20 + 30 + 20

        loginView.containerView.autoSetDimension(.height, toSize: height)
        loginView.scrollView.contentSize = loginView.containerView.bounds.size
    }

    func actionTapToSignInButton() {

        if loginView.mailField.text == "" {
            Utils.showAlert(title: "Error", message: "Email can not be empty!", viewController: self)
            return
        }

        if loginView.passwordField.text == "" {
            Utils.showAlert(title: "Error", message: "Password can not be empty!", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()
        Auth.auth().signIn(withEmail: loginView.mailField.text!, password: loginView.passwordField.text!, completion: { (user, error) in
            if error == nil {
                let uid = user?.uid

                DatabaseHelper.shared.getUser(id: uid!) {
                    user in
                    SwiftOverlays.removeAllBlockingOverlays()
                    if user != nil {
                        UserDefaultManager.getInstance().setIsInitApp(value: true)
                        self.present(MainViewController(), animated: true, completion: nil)
                    }
                    else {
                        Utils.showAlert(title: "Error", message: "Email or password is incorrect. Please try again!", viewController: self)
                    }
                }
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Email or password is incorrect. Please try again!", viewController: self)
            }
        })
    }

    func actionTapToCreateNewAccountButton() {
        let nav = UINavigationController(rootViewController: RegisterViewController())
        present(nav, animated: true, completion: nil)
    }

    func actionTapToForgotButton() {
        let nav = UINavigationController(rootViewController: ForgotPasswordViewController())
        present(nav, animated: true, completion: nil)
    }

    func actionTapToCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case loginView.mailField:
            if value != nil && value!.isValidEmail() {
                loginView.errorLabel.text = nil
                loginView.mailBorder.backgroundColor = Global.colorSeparator
                return true
            }
            loginView.errorLabel.text = "Invalid Email"
            loginView.mailBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        default:
            if value != nil && value!.isValidPassword() {
                loginView.errorLabel.text = nil
                loginView.passwordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            loginView.errorLabel.text = "Invalid password"
            loginView.passwordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginView.mailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                loginView.passwordField.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                actionTapToSignInButton()
                return true
            }
        }
        return false
    }
}
