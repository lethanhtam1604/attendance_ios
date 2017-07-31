//
//  ChangePasswordViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/5/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import SwiftOverlays
import Firebase

class ChangePasswordViewController: UIViewController {

    let changePasswordView = ChangePasswordView()
    var user: User?

    override func loadView() {
        view = changePasswordView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = "CHANGE PASSWORD"

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(actionTapToSaveButton))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton

        changePasswordView.previousPasswordField.delegate = self
        changePasswordView.newPasswordField.delegate = self
        changePasswordView.confirmPasswordField.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var fieldSize: CGFloat = 40

        if DeviceType.IS_IPAD {
            fieldSize = 50
        }

        let height: CGFloat = 10 + 20 + 10 + fieldSize + 10 + fieldSize + 10 + fieldSize

        changePasswordView.containerView.autoSetDimension(.height, toSize: height)
        changePasswordView.scrollView.contentSize = changePasswordView.containerView.bounds.size
    }

    func actionTapToSaveButton() {

        if changePasswordView.previousPasswordField.text == "" {
            Utils.showAlert(title: "Error", message: "Current Password can not be empty!", viewController: self)
            return
        }

        if changePasswordView.newPasswordField.text == "" {
            Utils.showAlert(title: "Error", message: "New Password can not be empty!", viewController: self)
            return
        }

        if changePasswordView.confirmPasswordField.text == "" {
            Utils.showAlert(title: "Error", message: "Confirm Password can not be empty!", viewController: self)
            return
        }

        if changePasswordView.confirmPasswordField.text != changePasswordView.newPasswordField.text {
            Utils.showAlert(title: "Error", message: "Confirm Password mismatch", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()
        if let user = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: changePasswordView.previousPasswordField.text!)

            user.reauthenticate(with: credential, completion: { (error) in
                if error != nil {
                    SwiftOverlays.removeAllBlockingOverlays()
                    Utils.showAlert(title: "Attendance", message: "Current password is incorrect. Please try again!", viewController: self)
                }
                else {
                    user.updatePassword(to: self.changePasswordView.newPasswordField.text!) { error in
                        SwiftOverlays.removeAllBlockingOverlays()
                        if error != nil {
                            Utils.showAlert(title: "Attendance", message: "Change password error!", viewController: self)
                        }
                        else {
                            Utils.showAlert(title: "Attendance", message: "Change password successfully!", viewController: self)
                        }
                    }
                }
            })
        }
        else {
            SwiftOverlays.removeAllBlockingOverlays()
            Utils.showAlert(title: "Attendance", message: "Change password error!", viewController: self)
        }
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }

    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case changePasswordView.previousPasswordField:
            if value != nil && value!.isValidPassword() {
                changePasswordView.errorLabel.text = nil
                changePasswordView.previousPasswordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            changePasswordView.errorLabel.text = "Invalid current password"
            changePasswordView.previousPasswordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        case changePasswordView.newPasswordField:
            if value != nil && value!.isValidPassword() {
                changePasswordView.errorLabel.text = nil
                changePasswordView.newPasswordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            changePasswordView.errorLabel.text = "Invalid new password"
            changePasswordView.newPasswordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        default:
            if value != nil && changePasswordView.newPasswordField.text != nil && value! == changePasswordView.newPasswordField.text! {
                changePasswordView.errorLabel.text = nil
                changePasswordView.confirmPasswordBorder.backgroundColor = Global.colorSeparator
                return true
            }
            changePasswordView.errorLabel.text = "Password mismatch"
            changePasswordView.confirmPasswordBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        }
        return false
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case changePasswordView.previousPasswordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                changePasswordView.newPasswordField.becomeFirstResponder()
                return true
            }
        case changePasswordView.newPasswordField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                changePasswordView.confirmPasswordField.becomeFirstResponder()
                return true
            }
        default:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                return true
            }
        }
        return false
    }
}
