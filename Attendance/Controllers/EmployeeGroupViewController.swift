//
//  EmployeeGroupViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import Firebase
import SwiftOverlays

class EmployeeGroupViewController: UIViewController {

    var employeeGroupView = EmployeeGroupView()

    var employees = [Employee]()
    var allEmployees = [Employee]()

    var groups = [Group]()
    var allGroups = [Group]()

    override func loadView() {
        view = employeeGroupView
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

        title = "STUDENTS/GROUPS"

        let addBarButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(actionTapToAddEmployeeButton))
        addBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addBarButton

        employeeGroupView.tableView.delegate = self
        employeeGroupView.tableView.dataSource = self
        employeeGroupView.tableView.emptyDataSetSource = self
        employeeGroupView.collectionView.delegate = self
        employeeGroupView.collectionView.dataSource = self
        employeeGroupView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        DatabaseHelper.shared.getAllEmployees(){
            employees in
            self.allEmployees = employees

            DatabaseHelper.shared.observeEmployees() {
                newEmployee in

                var flag = false

                for index in 0..<self.allEmployees.count {
                    if self.allEmployees[index].id == newEmployee.id {
                        self.allEmployees[index] = newEmployee
                        flag = true
                        break
                    }
                }

                if !flag {
                    self.allEmployees.append(newEmployee)
                }

                self.search()
            }

            DatabaseHelper.shared.observeDeleteEmployee() {
                newEmployee in

                for index in 0..<self.allEmployees.count {
                    if self.allEmployees[index].id == newEmployee.id {
                        self.allEmployees.remove(at: index)
                        self.search()
                        break
                    }
                }
            }
        }

        if let userId = Auth.auth().currentUser?.uid {
            employeeGroupView.indicator.startAnimating()
            DatabaseHelper.shared.getGroups(userId: userId) {
                groups in
                self.employeeGroupView.indicator.stopAnimating()
                self.allGroups = groups

                DatabaseHelper.shared.observeGroups(userId: userId) {
                    newGroup in

                    var flag = false

                    for index in 0..<self.allGroups.count {
                        if self.allGroups[index].id == newGroup.id {
                            self.allGroups[index] = newGroup
                            flag = true
                            break
                        }
                    }

                    if !flag {
                        self.allGroups.append(newGroup)
                    }

                    self.reloadGroup()
                }

                DatabaseHelper.shared.observeDeleteGroup(userId: userId) {
                    newGroup in

                    for index in 0..<self.allGroups.count {
                        if self.allGroups[index].id == newGroup.id {
                            self.allGroups.remove(at: index)
                            self.reloadGroup()
                            break
                        }
                    }
                }
            }
        }
    }

    func search() {

        let source = allEmployees

        let searchText = employeeGroupView.searchBar.text ?? ""
        var result = [Employee]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for item in source {
                if (item.name?.lowercased().contains(text)) ?? false || (item.employeeID?.lowercased().contains(text)) ?? false || (item.dob?.lowercased().contains(text)) ?? false || (item.gender?.lowercased().contains(text)) ?? false {
                    result.append(item)
                }
            }
        }

        employees.removeAll()
        employees.append(contentsOf: result)

        employeeGroupView.tableView.reloadData()
    }

    func reloadGroup() {

        groups.removeAll()
        groups.append(contentsOf: allGroups)

        employeeGroupView.collectionView.reloadData()
    }

    var viewPopupController: STPopupController!

    func actionTapToAddEmployeeButton() {
        let viewController = AddGroupViewController()
        viewController.addGroupDelegate = self
        viewPopupController = STPopupController(rootViewController: viewController)
        viewPopupController.containerView.layer.cornerRadius = 4
        viewPopupController.present(in: self)
    }

    func navigateToAddEmployeePage(employee: Employee?, group: Group?) {
        let viewController = AddEmployeeViewController()
        viewController.employee = employee
        viewController.group = group
        navigationController?.pushViewController(viewController, animated: true)
    }

    func actionHoldGroupView(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let index = longPressGestureRecognizer.view?.tag

            let optionMenu = UIAlertController(title: self.groups[index!].name, message: nil, preferredStyle: .actionSheet)
            optionMenu.view.tintColor = Global.colorMain

            let editAction = UIAlertAction(title: "Delete", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in

                let group = self.groups[index!]
                let userId = Auth.auth().currentUser?.uid

                if group.id != "" && userId != nil {
                    SwiftOverlays.showBlockingWaitOverlay()
                    DatabaseHelper.shared.deleteGroup(userId: userId!, groupId: group.id){
                        SwiftOverlays.removeAllBlockingOverlays()
                    }
                }
                else {
                    Utils.showAlert(title: "Attendance", message: "Delete error. Please try again!", viewController: self)
                }
            })

            let deleteAction = UIAlertAction(title: "Edit", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let viewController = AddGroupViewController()
                viewController.addGroupDelegate = self
                viewController.group = self.groups[index!]
                self.viewPopupController = STPopupController(rootViewController: viewController)
                self.viewPopupController.containerView.layer.cornerRadius = 4
                self.viewPopupController.present(in: self)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })

            optionMenu.addAction(editAction)
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(cancelAction)
            optionMenu.popoverPresentationController?.sourceView = self.view
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            self.present(optionMenu, animated: true, completion: nil)
        }
    }
}

extension EmployeeGroupViewController: AddEmployeeDelegate, AddGroupDelegate {

    func actionTapToAddButton() {
        viewPopupController.dismiss()
    }

    func actionTapToCancelButton() {
        viewPopupController.dismiss()
    }
}

extension EmployeeGroupViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let employee = employees[indexPath.row]

        let delete = UITableViewRowAction(style: .normal, title: "DELETE") { action, index in
            tableView.setEditing(false, animated: true)

            if employee.id != "" {
                SwiftOverlays.showBlockingWaitOverlay()
                DatabaseHelper.shared.deleteEmployee(employeeId: employee.id) {
                    SwiftOverlays.removeAllBlockingOverlays()
                    if self.employees.count == 0 {
                        tableView.reloadData()
                    }
                }
            }
            else {
                Utils.showAlert(title: "Attendance", message: "Delete error. Please try again!", viewController: self)
            }
        }
        delete.backgroundColor = Global.colorDeleteBtn

        let edit = UITableViewRowAction(style: .normal, title: "EDIT") { action, index in
            tableView.setEditing(false, animated: true)
            self.navigateToAddEmployeePage(employee: employee, group: nil)
        }
        edit.backgroundColor = Global.colorEditBtn

        return [edit, delete]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let employee = employees[indexPath.row]

        let rectName = NSString(string: employee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - (95 + 24), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        var height: CGFloat = rectName.height + 10 + 10 + 10

        if height < 70 {
            height = 70
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none

        cell.bindingData(employee: employees[indexPath.row])

        return cell
    }
}

extension EmployeeGroupViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        navigateToAddEmployeePage(employee: employees[indexPath.row], group: nil)
    }
}

extension EmployeeGroupViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No student list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension EmployeeGroupViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmployeeGroupCollectionViewCell

        let group = groups[indexPath.row]
        cell.bindingData(group: group)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(actionHoldGroupView))
        cell.addGestureRecognizer(longPressRecognizer)
        longPressRecognizer.view?.tag = indexPath.row

        return cell
    }
}

extension EmployeeGroupViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let viewController = EmployeeViewController()
        viewController.group = groups[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension EmployeeGroupViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
