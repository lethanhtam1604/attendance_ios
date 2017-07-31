//
//  AddEmployeeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/30/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import INSPhotoGallery
import SwiftOverlays
import DZNEmptyDataSet

protocol AddEmployeeDelegate: class {
    func actionTapToAddButton()
    func actionTapToCancelButton()
}

class AddEmployeeViewController: UIViewController {

    let addEmployeeView = AddEmployeeView()
    var employeHeaderView: EmployeHeaderView!

    open weak var addEmployeeDelegate: AddEmployeeDelegate?

    var avatar = [INSPhotoViewable]()
    var urlPhotos = [ImageUrl]()
    var photos = [INSPhotoViewable]()

    var employee: Employee?
    var group: Group?
    var imageUrl: String?

    var isLoadHeader = false

    override func loadView() {
        view = addEmployeeView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = "CREATE NEW STUDENT"

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToCancelButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        let saveBarButton = UIBarButtonItem(title: "SAVE", style: .done, target: self, action: #selector(actionTapToSaveButton))
        saveBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = saveBarButton

        addEmployeeView.collectionView.delegate = self
        addEmployeeView.collectionView.dataSource = self
    }

    func loadData() {

        let image = UIImage(named: "ic_user")!
        self.avatar.removeAll()
        let tmppho = INSPhoto(image: image, thumbnailImage: image)
        self.avatar.append(tmppho)

        if let newEmployee = employee {
            title = "EDIT STUDENT"
            employeHeaderView.idField.text = newEmployee.employeeID
            employeHeaderView.nameField.text = newEmployee.name
            employeHeaderView.dobField.text = newEmployee.dob
            employeHeaderView.genderField.text = newEmployee.gender
            if let url = newEmployee.avatarUrl {
                if url != "" {
                    imageUrl = url
                    let url_go = URL.init(string: url)
                    let tmppho = INSPhoto(imageURL: url_go, thumbnailImageURL: url_go)
                    self.avatar.removeAll()
                    self.avatar.append(tmppho)
                    employeHeaderView.avatarButton.sd_setImage(with: URL(string: url), for: .normal)
                }
            }

            urlPhotos = newEmployee.photos

            for item in urlPhotos {
                let url_go = URL.init(string: item.image ?? "")
                let tmppho = INSPhoto(imageURL: url_go, thumbnailImageURL: url_go)
                photos.append(tmppho)
            }

            addEmployeeView.collectionView.reloadData()
        }
        else {
            employee = Employee()
        }
    }

    func actionTapToAvatarButton(_ sender: UIButton) {

        var tookPicture = "0"

        if sender.tag != -1 {
            tookPicture = "1"
        }

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorMain

        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.tookPicture = tookPicture
            cameraViewController.cameraDelegate = self
            self.present(cameraViewController, animated: false, completion: nil)
        })

        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraViewController = CameraViewController()
            cameraViewController.tookPicture = tookPicture
            cameraViewController.cameraDelegate = self
            cameraViewController.pickImage = 1
            self.present(cameraViewController, animated: false, completion: nil)
        })

        let viewPictureAction = UIAlertAction(title: "View Picture", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let galleryPreview = INSPhotosViewController(photos: self.avatar)
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
        optionMenu.popoverPresentationController?.sourceView = employeHeaderView.avatarButton
        optionMenu.popoverPresentationController?.sourceRect = employeHeaderView.avatarButton.bounds

        self.present(optionMenu, animated: true, completion: nil)
    }

    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM-dd-yyyy"

            if fromDate != nil {
                employeHeaderView.dobField.text = dateFormatter.string(from: fromDate! as Date)
            }
        }
    }

    func actionTapToDobView() {
        employeHeaderView.nameField.resignFirstResponder()
        var date = NSDate()
        if(fromDate != nil) {
            date = fromDate!
        }

        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.fromDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController

        datePickerViewController.view.tintColor = Global.colorMain

        present(datePickerViewController, animated: true, completion: nil)
    }

    func actionTapToGenderView() {
        employeHeaderView.nameField.resignFirstResponder()
        employeHeaderView.genderDropDown.dataSource = ["Male", "Female"]
        employeHeaderView.genderDropDown.show()
    }

    func actionTapToSaveButton() {

        if imageUrl == nil {
            Utils.showAlert(title: "Error", message: "Avatar can not be empty!", viewController: self)
            return
        }

        if employeHeaderView.idField.text == "" {
            Utils.showAlert(title: "Error", message: "ID can not be empty!", viewController: self)
            return
        }

        if employeHeaderView.nameField.text == "" {
            Utils.showAlert(title: "Error", message: "Name can not be empty!", viewController: self)
            return
        }

        if employeHeaderView.dobField.text == "" {
            Utils.showAlert(title: "Error", message: "DOB can not be empty!", viewController: self)
            return
        }

        if employeHeaderView.genderField.text == "" {
            Utils.showAlert(title: "Error", message: "Gender can not be empty!", viewController: self)
            return
        }

        if urlPhotos.count <= 1 {
            Utils.showAlert(title: "Error", message: "There are at least two photos", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()

        if employee == nil {
            employee = Employee()
        }

        employee?.avatarUrl = imageUrl
        employee?.employeeID = employeHeaderView.idField.text
        employee?.name = employeHeaderView.nameField.text
        employee?.dob = employeHeaderView.dobField.text
        employee?.gender = employeHeaderView.genderField.text
        employee?.photos = urlPhotos

        if let newGroup = group {
            employee?.groupId = newGroup.id
        }

        DatabaseHelper.shared.getIdMax { (idMax) in
            self.employee?.label = idMax

            DatabaseHelper.shared.saveEmployee(employee: self.employee!) { _ in
                SwiftOverlays.removeAllBlockingOverlays()
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func actionTapToCancelButton() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension AddEmployeeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: view.bounds.width, height: 100 + 350)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if !isLoadHeader {
            isLoadHeader = true
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! EmployeHeaderView


            headerView.idField.delegate = self
            headerView.nameField.delegate = self

            headerView.avatarButton.tag = -1
            headerView.avatarButton.addTarget(self, action: #selector(actionTapToAvatarButton), for: .touchUpInside)
            headerView.dobAbstract.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(actionTapToDobView)))
            headerView.genderAbstract.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(actionTapToGenderView)))
            headerView.addBtn.addTarget(self, action: #selector(actionTapToAvatarButton), for: .touchUpInside)
            headerView.addBtn.tag = 0

            employeHeaderView = headerView

            loadData()

            return headerView
        }
        else {
            return employeHeaderView
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell

        cell.photoBtn.tag = indexPath.row
        cell.bindingData(image: urlPhotos[indexPath.row].image ?? "")

        return cell
    }
}

extension AddEmployeeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = Global.colorMain

        let deletePhotoAction = UIAlertAction(title: "Delete Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let indexPath = NSIndexPath(item: indexPath.row, section: 0)

            self.photos.remove(at: indexPath.row)
            self.urlPhotos.remove(at: indexPath.row)
            self.addEmployeeView.collectionView.deleteItems(at: [indexPath as IndexPath])
        })

        let viewProfilePictureAction = UIAlertAction(title: "View Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in

            let indexPath = NSIndexPath(item: indexPath.row, section: 0)
            let cell = self.addEmployeeView.collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCollectionViewCell
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

        optionMenu.addAction(deletePhotoAction)
        optionMenu.addAction(viewProfilePictureAction)
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)

        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}

extension AddEmployeeViewController: CameraDelegate {

    func tookPicture(url: String, image: UIImage) {
        SwiftOverlays.showBlockingWaitOverlay()
        DatabaseHelper.shared.uploadImage(localImage: image) {
            path in
            if let newUrl = path {
                SwiftOverlays.removeAllBlockingOverlays()

                let url_go = URL.init(string: newUrl)
                let tmppho = INSPhoto(imageURL: url_go, thumbnailImageURL: url_go)

                if  url != "0" {
                    let imageUrl = ImageUrl()
                    imageUrl.image = newUrl
                    self.urlPhotos.append(imageUrl)
                    self.photos.append(tmppho)
                    let indexPath = IndexPath(item: self.photos.count - 1, section: 0)
                    self.addEmployeeView.collectionView.insertItems(at: [indexPath])
                    self.addEmployeeView.collectionView.reloadItems(at: [indexPath])
                }
                else {
                    self.avatar.removeAll()
                    self.avatar.append(tmppho)
                    self.employeHeaderView.avatarButton.sd_setImage(with: URL(string: newUrl), for: .normal)
                    self.imageUrl = newUrl
                }
            }
            else {
                SwiftOverlays.removeAllBlockingOverlays()
                Utils.showAlert(title: "Error", message: "Could not connect to server. Please try again!", viewController: self)
            }
        }
    }
}

extension AddEmployeeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case employeHeaderView.idField:
            textField.resignFirstResponder()
            employeHeaderView.nameField.becomeFirstResponder()
            return true
            
        case employeHeaderView.nameField:
            textField.resignFirstResponder()
            actionTapToDobView()
            return true
            
        default:
            textField.resignFirstResponder()
            return true
        }
    }
}
