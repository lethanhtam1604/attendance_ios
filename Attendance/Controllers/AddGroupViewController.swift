//
//  AddGroupViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import INSPhotoGallery
import SwiftOverlays
import Firebase

protocol AddGroupDelegate: class {
    func actionTapToAddButton()
    func actionTapToCancelButton()
}

class AddGroupViewController: UIViewController {

    let addGroupView = AddGroupView()
    open weak var addGroupDelegate: AddGroupDelegate?
    var photos: [INSPhotoViewable] = [INSPhotoViewable]()
    var group: Group?
    var imageUrl: String?

    override func loadView() {
        view = addGroupView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ADD NEW GROUP"

        var portraitSize: CGSize!
        var landscapeSize: CGSize!

        if DeviceType.IS_IPAD {
            portraitSize = CGSize(width: Global.SCREEN_WIDTH - 300, height: Global.SCREEN_HEIGHT - 500)
            landscapeSize = CGSize(width: Global.SCREEN_HEIGHT - 450, height: Global.SCREEN_WIDTH - 200)
        }
        else {
            portraitSize = CGSize(width: Global.SCREEN_WIDTH - 50, height: Global.SCREEN_HEIGHT - 400)
            landscapeSize = CGSize(width: Global.SCREEN_HEIGHT - 200, height: Global.SCREEN_WIDTH - 100)
        }

        self.contentSizeInPopup = portraitSize
        self.landscapeContentSizeInPopup = landscapeSize

        addGroupView.nameField.delegate = self

        addGroupView.avatarButton.addTarget(self, action: #selector(actionTapToAvatarButton), for: .touchUpInside)
        addGroupView.addBtn.addTarget(self, action: #selector(actionTapToAddButton), for: .touchUpInside)
        addGroupView.cancelBtn.addTarget(self, action: #selector(actionTapToCancelButton), for: .touchUpInside)

        loadData()
    }

    func loadData() {
        createPhotoFromImage(image: UIImage(named: "Teamwork-Icon")!)

        if let newGroup = group {
            title = "EDIT GROUP"
            addGroupView.nameField.text = newGroup.name
            if let url = newGroup.imageUrl {
                if url != "" {
                    createPhotoFromURL(url: url)
                    addGroupView.avatarButton.sd_setImage(with: URL(string: url), for: .normal)
                }
            }
        }
        else {
            group = Group()
        }
    }

    func actionTapToAvatarButton() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorMain

        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            self.present(cameraViewController, animated: false, completion: nil)
        })

        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.cameraDelegate = self
            cameraViewController.pickImage = 1
            self.present(cameraViewController, animated: false, completion: nil)
        })

        let viewPictureAction = UIAlertAction(title: "View Picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in

            let galleryPreview = INSPhotosViewController(photos: self.photos)
            let overlayViewBar = (galleryPreview.overlayView as! INSPhotosOverlayView).navigationBar

            overlayViewBar?.autoPin(toTopLayoutGuideOf: galleryPreview, withInset: 0.0)

            galleryPreview.view.backgroundColor = UIColor.black
            galleryPreview.view.tintColor = Global.colorMain
            self.present(galleryPreview, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(viewPictureAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = addGroupView.avatarButton
        optionMenu.popoverPresentationController?.sourceRect = addGroupView.avatarButton.bounds

        self.present(optionMenu, animated: true, completion: nil)
    }

    func createPhotoFromURL(url: String) {
        self.photos.removeAll()
        let url_go = URL.init(string: url)
        let tmppho = INSPhoto(imageURL: url_go, thumbnailImageURL: url_go)
        self.photos.append(tmppho)
    }

    func createPhotoFromImage(image: UIImage) {
        self.photos.removeAll()
        let tmppho = INSPhoto(image: image, thumbnailImage: image)
        self.photos.append(tmppho)
    }

    func actionTapToAddButton() {
        if addGroupView.nameField.text == "" {
            Utils.showAlert(title: "Error", message: "Name can not be empty!", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()
        if let userId = Auth.auth().currentUser?.uid {

            if group == nil {
                group = Group()
            }

            group?.imageUrl = imageUrl
            group?.name = addGroupView.nameField.text

            DatabaseHelper.shared.saveGroup(userId: userId, group: group!) {_ in
                SwiftOverlays.removeAllBlockingOverlays()
                self.addGroupDelegate?.actionTapToAddButton()
            }
        }
        else {
            SwiftOverlays.removeAllBlockingOverlays()
            Utils.showAlert(title: "Attendance", message: "Add Group error. Please try again!", viewController: self)
        }
    }

    func actionTapToCancelButton() {
        addGroupDelegate?.actionTapToCancelButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let height: CGFloat = 20 + 80 + 20 + 40 + 20

        addGroupView.containerView.autoSetDimension(.height, toSize: height)
        addGroupView.scrollView.contentSize = addGroupView.containerView.bounds.size
    }
}

extension AddGroupViewController: CameraDelegate {

    func tookPicture(url: String, image: UIImage) {
        SwiftOverlays.showBlockingWaitOverlay()
        DatabaseHelper.shared.uploadImage(localImage: image) {
            url in
            if let newUrl = url {
                SwiftOverlays.removeAllBlockingOverlays()
                self.createPhotoFromURL(url: newUrl)
                self.addGroupView.avatarButton.sd_setImage(with: URL(string: newUrl), for: .normal)
                self.imageUrl = newUrl
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
    }
}

extension AddGroupViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case addGroupView.nameField:
            textField.resignFirstResponder()
            return true
            
        default:
            textField.resignFirstResponder()
            return true
        }
    }
}
