//
//  TrainingDetailViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import INSPhotoGallery
import SwiftOverlays
import Firebase

class TrainingDetailViewController: UIViewController {

    let trainingDetailView = TrainingDetailView()

    var labels = [Int64]()
    var urlPhotos = [UIImage]()
    var photos = [INSPhotoViewable]()

    var group = Group()
    var employees = [Employee]()

    var faceRecognizer = FJFaceRecognizer.sharedManager()

    var user: User?

    override func loadView() {
        view = trainingDetailView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = "PHOTOS"

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        let trainingBarButton = UIBarButtonItem(title: "TRAINING", style: .done, target: self, action: #selector(actionTapToTrainingButton))
        trainingBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = trainingBarButton

        trainingDetailView.collectionView.delegate = self
        trainingDetailView.collectionView.dataSource = self

        loadData()
    }

    func loadData() {
        if group.id != "" {
            trainingDetailView.indicator.startAnimating()
            DatabaseHelper.shared.getEmployees(groupId: group.id){ (employees) in
                self.employees = employees
                self.search()
                self.trainingDetailView.indicator.stopAnimating()
            }
        }

        if let userId = Auth.auth().currentUser?.uid {
            DatabaseHelper.shared.getUser(id: userId) {
                user in
                if let newUser = user {
                    self.user = newUser
                }

                DatabaseHelper.shared.observeUsers() {
                    newUser in
                    if newUser.id == userId {
                        self.user = newUser
                    }
                }
            }
        }
    }

    func search() {

        labels = [Int64]()
        urlPhotos = [UIImage]()
        photos = [INSPhotoViewable]()

        for item in employees {
            for imageUrl in item.photos {
                if let newUrl = imageUrl.image {
                    DatabaseHelper.shared.fetchImage(label: item.label ?? 0, url: newUrl, completion: { (label, image) in
                        let tmppho = INSPhoto(image: image, thumbnailImage: image)
                        self.photos.append(tmppho)
                        self.labels.append(label)
                        self.urlPhotos.append(image ?? UIImage())

                        self.trainingDetailView.collectionView.reloadData()
                    })
                }
            }
        }
    }

    func actionTapToTrainingButton() {
        SwiftOverlays.showBlockingWaitOverlay()
        DispatchQueue.global(qos: .userInitiated).async {
            for index in 0..<self.photos.count {
                self.faceRecognizer?.createData(forTrain: self.urlPhotos[index], label: Int(self.labels[index]))
            }
            self.faceRecognizer?.trainingFace()
            self.faceRecognizer?.save(Utils.faceModelFileURL(fileName: "training-model.xml").path)

            do {
                let url = Utils.faceModelFileURL(fileName: "training-model.xml")
                let data = try Data(contentsOf:url)

                let file = File()
                file.mimeType = "text/xml"
                file.nameFile = "training-model.xml"
                file.data = data

                DatabaseHelper.shared.uploadFile(file: file) {
                    url in

                    if let newUser = self.user {
                        newUser.trainingFileUrl = url

                        DatabaseHelper.shared.saveUser(user: newUser) {
                            SwiftOverlays.removeAllBlockingOverlays()
                            Utils.showAlert(title: "Attendance", message: "Training data successfully!", viewController: self)
                        }
                    }
                    else {
                        SwiftOverlays.removeAllBlockingOverlays()
                        Utils.showAlert(title: "Attendance", message: "Training data error. Please try again!", viewController: self)
                    }
                }
                

            } catch {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Attendance", message: "Training data error. Please try again!", viewController: self)
            }
        }
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension TrainingDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell

        cell.photoBtn.tag = indexPath.row
        cell.photoBtn.image = urlPhotos[indexPath.row]
        return cell
    }
}

extension TrainingDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorMain

        let viewProfilePictureAction = UIAlertAction(title: "View Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in

            let indexPath = NSIndexPath(item: indexPath.row, section: 0)
            let cell = self.trainingDetailView.collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCollectionViewCell
            let galleryPreview = INSPhotosViewController(photos: self.photos, initialPhoto: self.photos[indexPath.row], referenceView: cell)
            let overlayViewBar = (galleryPreview.overlayView as! INSPhotosOverlayView).navigationBar

            overlayViewBar?.autoPin(toTopLayoutGuideOf: galleryPreview, withInset: 0.0)

            galleryPreview.view.backgroundColor = UIColor.black
            galleryPreview.view.tintColor = UIColor.white
            self.present(galleryPreview, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(viewProfilePictureAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}
