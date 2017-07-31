//
//  RealTimeCameraViewController.swift
//  RealTimeFace
//
//  Created by hung nguyen on 7/5/17.
//  Copyright © 2017 hung nguyen. All rights reserved.
//

import UIKit
import Firebase

class RealTimeCameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIImageView!

    var faceDetector =  FJFaceDetector()
    var tapGestureRecognizer: UITapGestureRecognizer?
    var faceRecognizer = FJFaceRecognizer.sharedManager()

    var group = Group()
    var employees = [Employee]()
    var photos = [UIImage]()
    var labels = [Int64]()

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = Global.colorMain
        navigationController?.navigationBar.tintColor = Global.colorMain
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        title = "CAMERA"

        faceDetector = FJFaceDetector(cameraView: cameraView, scale: 2.0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionTapOnCamera))
        view.addGestureRecognizer(tapGestureRecognizer!)
        view.isUserInteractionEnabled = true

        DatabaseHelper.shared.getAllEmployees { (employees) in
            self.employees = employees
        }


        if let userId = Auth.auth().currentUser?.uid {
            DatabaseHelper.shared.getUser(id: userId) {
                user in
                if let newUser = user {
                    self.user = newUser
                    self.saveTrainingModel()
                }

                DatabaseHelper.shared.observeUsers() {
                    newUser in
                    if newUser.id == userId {
                        self.user = newUser
                        self.saveTrainingModel()
                    }
                }
            }
        }
    }

    func saveTrainingModel() {
        if let newUser = user {
            DatabaseHelper.shared.downloadFile(url: newUser.trainingFileUrl ?? "") { (data) in
                do {
                    try data?.write(to: self.faceModelFileURL())
                    self.faceRecognizer?.load(self.faceModelFileURL().path)
                }
                catch{

                }
            }
        }
    }

    func faceModelFileURL() -> URL {
        let paths: [Any] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths.last as! URL
        let modelURL = documentsURL.appendingPathComponent("training-model.xml")

        return modelURL
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        faceDetector.startCapture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        faceDetector.stopCapture()
    }

    func actionTapOnCamera(_ tapGesture: UITapGestureRecognizer) {

        //        let detectedFaces = faceDetector.detectedFaces()
        //        let windowSize: CGSize = view.bounds.size
        //        for val in detectedFaces! {
        //            let faceRect: CGRect = val as! CGRect
        //
        //            let tapPoint: CGPoint = tapGesture.location(in: nil)
        //            let scaledPoint = CGPoint(x: CGFloat(tapPoint.x / windowSize.width), y: CGFloat(tapPoint.y / windowSize.height))
        //            if faceRect.contains(scaledPoint) {
        //                print("tapped on face: \(NSStringFromCGRect(faceRect))")

        let img = faceDetector.getImageFromCamera()

        let realTimeStoryBoard = UIStoryboard(name: "RealTime", bundle: nil)
        if let viewController = realTimeStoryBoard.instantiateViewController(withIdentifier: "FaceRecognitionViewController") as? FaceRecognitionViewController {
            viewController.inputImage = img
            viewController.employees = employees
            navigationController?.pushViewController(viewController, animated: false)
            
        }
        
    }
}
