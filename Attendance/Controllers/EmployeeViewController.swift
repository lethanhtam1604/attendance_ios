//
//  EmployeeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/27/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import SwiftOverlays

class EmployeeViewController: UIViewController {

    let employeeView = EmployeeView()

    var group = Group()
    var employees = [Employee]()
    var allEmployees = [Employee]()

    override func loadView() {
        view = employeeView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = group.name

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        let addBarButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(actionTapToAddEmployeeButton))
        addBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = addBarButton

        employeeView.tableView.delegate = self
        employeeView.tableView.dataSource = self
        employeeView.tableView.emptyDataSetSource = self
        employeeView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {
        if group.id != "" {
            employeeView.indicator.startAnimating()
            DatabaseHelper.shared.getEmployees(groupId: group.id) {
                employees in
                self.employeeView.indicator.stopAnimating()
                self.allEmployees = employees
                self.search()
            }
        }
    }

    func search() {
        let source = allEmployees

        let searchText = employeeView.searchBar.text ?? ""
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

        employeeView.tableView.reloadData()
    }

    var viewPopupController: STPopupController!

    func actionTapToAddEmployeeButton() {
        navigateToAddEmployeePage(employee: nil, group: group)
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }

    func navigateToAddEmployeePage(employee: Employee?, group: Group?) {
        let viewController = AddEmployeeViewController()
        viewController.employee = employee
        viewController.group = group
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension EmployeeViewController: UITableViewDataSource {

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

            if self.group.id != "" && employee.id != "" {
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
            self.navigateToAddEmployeePage(employee: employee, group: self.group)
        }
        edit.backgroundColor = Global.colorEditBtn

        return [edit, delete]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let employee = employees[indexPath.row]

        let rectName = NSString(string: employee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 135, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

        var height: CGFloat = rectName.height + 10 + 10

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

extension EmployeeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let employee = employees[indexPath.row]
        navigateToAddEmployeePage(employee: employee, group: group)
    }
}

extension EmployeeViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No student list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension EmployeeViewController: UISearchBarDelegate {

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
