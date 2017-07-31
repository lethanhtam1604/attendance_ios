//
//  FaceRecognitionViewController.swift
//  RealTimeFace
//
//  Created by hung nguyen on 7/2/17.
//  Copyright © 2017 hung nguyen. All rights reserved.
//

import UIKit
import SwiftOverlays

class FaceRecognitionViewController: UIViewController {

    @IBOutlet weak var inputImageView: UIImageView!

    var group = Group()
    var employees = [Employee]()
    var currentEmployee = Employee()
    var currentAttendance: Attendance?

    var inputImage: UIImage!
    private var confidence: Double = 0.0

    var faceRecognizer = FJFaceRecognizer.sharedManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorMain
        view.addTapToDismiss()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = group.name

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        inputImageView.image = inputImage


        let label = self.faceRecognizer?.predict(inputImage, confidence: 0)
        if (label == -1) {
            Utils.showAlert(title: "Hello", message: "Who are you? I was thinking that you are not member of Citynow", viewController: self)
        }
        else {
            SwiftOverlays.showBlockingWaitOverlay()
            for item in employees {
                if Int(item.label!) == label {
                    currentEmployee = item
                    let name = item.name ?? ""
                    DatabaseHelper.shared.getAttendance(date: Utils.getCurrentDate() ?? "1", employeeId: item.id) {
                        attendance in
                        self.currentAttendance = attendance
                        SwiftOverlays.removeAllBlockingOverlays()
                        Utils.showAlertAction(title: "Hello", message: "Are you " + name + "?", viewController: self, alertDelegate: self)
                    }
                    break
                }
            }
        }
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: false)
    }

    func faceModelFileURL() -> URL {
        let paths: [Any] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths.last as! URL
        let modelURL = documentsURL.appendingPathComponent("face-model.xml")

        return modelURL
    }

    @IBAction func actionTapToCorrectButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: false)
    }

    @IBAction func actionTapToWrongButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: false)
    }
}

extension FaceRecognitionViewController: AlertDelegate {

    func actionTapToYesButton() {

        SwiftOverlays.showBlockingWaitOverlay()
        let attendanceTime = AttendanceTime()
        attendanceTime.time = Utils.getCurrentTime()

        if currentAttendance == nil {
            currentAttendance = Attendance()
            currentAttendance?.employeeId = currentEmployee.id
            currentAttendance?.groupId = currentEmployee.groupId
        }

        currentAttendance?.attendanceTimes.append(attendanceTime)

        DatabaseHelper.shared.saveAttendance(date: Utils.getCurrentDate()!, attendance: currentAttendance!) {
            SwiftOverlays.removeAllBlockingOverlays()
            _ = self.navigationController?.popViewController(animated: false)
        }
    }

    func actionTapToNoButton() {
        _ = navigationController?.popViewController(animated: false)
    }
}
