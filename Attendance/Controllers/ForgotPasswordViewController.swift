//
//  ForgotPasswordViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import SwiftOverlays
import Firebase

class ForgotPasswordViewController: UIViewController {

    let forgotPasswordView = ForgotPasswordView()
    let usersRef = Database.database().reference(withPath: "users")

    override func loadView() {
        view = forgotPasswordView
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

        title = "FORGOT PASSWORD"

        let closeBarButton = UIBarButtonItem(image: UIImage(named: "ic_close_white"), style: .done, target: self, action: #selector(actionTapToCloseButton))
        closeBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = closeBarButton

        forgotPasswordView.mailField.delegate = self

        forgotPasswordView.recoverPasswordButton.addTarget(self, action: #selector(actionTapToRecoverPasswordButton), for: .touchUpInside)
        forgotPasswordView.signInButton.addTarget(self, action: #selector(actionTapToLogInButton), for: .touchUpInside)
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

        let rectTitle = NSString(string: forgotPasswordView.titleLabel.text ?? "").boundingRect(with: CGSize(width: view.frame.width - 130, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 18)!], context: nil)

        let height: CGFloat = 50 + imageSize + 30 + 20 + 20 + rectTitle.height + 20 + fieldSize + 40 + buttonSize + 20 + 30 + 20

        forgotPasswordView.containerView.autoSetDimension(.height, toSize: height)
        forgotPasswordView.scrollView.contentSize = forgotPasswordView.containerView.bounds.size
    }

    func actionTapToRecoverPasswordButton() {

        if forgotPasswordView.mailField.text == "" {
            Utils.showAlert(title: "Error", message: "Email can not be empty!", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()
        usersRef.queryOrdered(byChild: "email").observe(.value, with: { snapshot in
            var flag = false
            for item in snapshot.children {
                let user = User(item as! DataSnapshot)
                if user.email == self.forgotPasswordView.mailField.text {
                    flag = true
                    break
                }
            }

            if flag {
                Auth.auth().sendPasswordReset(withEmail: self.forgotPasswordView.mailField.text!) { error in
                    if error == nil {
                        Utils.showAlert(title: "Successfully", message: "Your new password has been sent to " + self.forgotPasswordView.mailField.text! + ". Please check your email!", viewController: self)
                    }
                    else {
                        Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
                    }
                    SwiftOverlays.removeAllBlockingOverlays()
                }
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "This email have not yet registered. Please try again!", viewController: self)
            }
        })
    }
    func actionTapToLogInButton() {
        dismiss(animated: true, completion: nil)
    }

    func actionTapToCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    func checkInput(textField: UITextField, value: String?) -> Bool {
        switch textField {
        case forgotPasswordView.mailField:
            if value != nil && value!.isValidEmail() {
                forgotPasswordView.errorLabel.text = nil
                forgotPasswordView.mailBorder.backgroundColor = Global.colorSeparator
                return true
            }
            forgotPasswordView.errorLabel.text = "Invalid Email"
            forgotPasswordView.mailBorder.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            
        default:
            return true
        }
        return false
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        _ = checkInput(textField: textField, value: newString)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case forgotPasswordView.mailField:
            if checkInput(textField: textField, value: textField.text) {
                textField.resignFirstResponder()
                actionTapToRecoverPasswordButton()
                return true
            }
        default:
            return true
        }
        return false
    }
}
