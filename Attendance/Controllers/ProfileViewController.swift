//
//  ProfileViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/5/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import SwiftOverlays
import Firebase

class ProfileViewController: UIViewController {

    let profileView = ProfileView()
    var user: User?

    override func loadView() {
        view = profileView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = "PROFILE"

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(actionTapToSaveButton))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: Global.colorMain,NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton

        profileView.nameField.delegate = self
        profileView.mailField.delegate = self
        profileView.phoneField.delegate = self

        profileView.changePasswordButton.addTarget(self, action: #selector(actionTapToChnagePasswordButton), for: .touchUpInside)

        loadData()
    }

    func loadData() {
        if let userId = Auth.auth().currentUser?.uid {
            DatabaseHelper.shared.getUser(id: userId) {
                user in
                if let newUser = user {
                    self.user = newUser
                    self.updateUser(user: newUser)
                }

                DatabaseHelper.shared.observeUsers() {
                    newUser in
                    if newUser.id == userId {
                        self.user = newUser
                        self.updateUser(user: newUser)
                    }
                }
            }
        }
    }

    func updateUser(user: User) {
        profileView.nameField.text = user.name
        profileView.mailField.text = user.email
        profileView.phoneField.text = user.phone
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var buttonSize: CGFloat = 40
        var fieldSize: CGFloat = 40

        if DeviceType.IS_IPAD {
            buttonSize = 50
            fieldSize = 50
        }

        let height: CGFloat = 10 + 20 + 10 + fieldSize + 10 + fieldSize + 10 + fieldSize + 30 + buttonSize + 20

        profileView.containerView.autoSetDimension(.height, toSize: height)
        profileView.scrollView.contentSize = profileView.containerView.bounds.size
    }

    func actionTapToSaveButton() {

        if profileView.nameField.text == "" {
            Utils.showAlert(title: "Error", message: "Name can not be empty!", viewController: self)
            return
        }

        if profileView.phoneField.text == "" {
            Utils.showAlert(title: "Error", message: "Phone can not be empty!", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()

        if let newUser = user {
            newUser.name = profileView.nameField.text
            newUser.phone = profileView.phoneField.text

            DatabaseHelper.shared.saveUser(user: newUser) {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Attendance", message: "Update profile successfully!", viewController: self)
            }
        }
        else {
            SwiftOverlays.removeAllBlockingOverlays()
            Utils.showAlert(title: "Attendance", message: "Update profile error. Please try again!", viewController: self)
        }
    }

    func actionTapToChnagePasswordButton() {
        navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }

    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case profileView.nameField:
            if value != nil && value!.isValidName() {
                profileView.errorLabel.text = nil
                profileView.nameBorder.backgroundColor = Global.colorSeparator
                return true
            }
            profileView.errorLabel.text = "Invalid name"
            profileView.nameBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        case profileView.phoneField:
            if value != nil && value!.isValidPhone() {
                profileView.errorLabel.text = nil
                profileView.phoneBorder.backgroundColor = Global.colorSeparator
                return true
            }
            profileView.errorLabel.text = "Invalid phone"
            profileView.phoneBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        default:
            return true
        }
        return false
    }
}

extension ProfileViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case profileView.nameField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                profileView.mailField.becomeFirstResponder()
                return true
            }
        case profileView.mailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                profileView.phoneField.becomeFirstResponder()
                return true
            }
        case profileView.phoneField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                return true
            }
        default:
            return true
        }
        return false
    }
}
