//
//  GroupViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/14/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase

protocol ApplyGroupDelegate: class {
    func actionTapToApplyButton(currentGroup: Group?)
}

class GroupViewController: UIViewController {

    var groupView = GroupView()

    var employees = [Employee]()
    var allEmployees = [Employee]()

    var groups = [Group]()
    var allGroups = [Group]()

    weak var currentGroup: Group?
    weak open var applyGroupDelegate: ApplyGroupDelegate?
    var currentIndex = -1

    override func loadView() {
        view = groupView
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

        title = "GROUPS"

        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(actionTapToCancelButton))
        cancelBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton

        let applyBarButton = UIBarButtonItem(title: "APPLY", style: .done, target: self, action: #selector(actionTapToApplyButton))
        applyBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = applyBarButton

        groupView.tableView.delegate = self
        groupView.tableView.dataSource = self
        groupView.tableView.emptyDataSetSource = self
        groupView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        if let userId = Auth.auth().currentUser?.uid {
            groupView.indicator.startAnimating()
            DatabaseHelper.shared.getGroups(userId: userId) {
                groups in
                self.groupView.indicator.stopAnimating()
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

                    self.search()
                }

                DatabaseHelper.shared.observeDeleteGroup(userId: userId) {
                    newGroup in

                    for index in 0..<self.allGroups.count {
                        if self.allGroups[index].id == newGroup.id {
                            self.allGroups.remove(at: index)
                            self.search()
                            break
                        }
                    }
                }
            }
        }
    }

    func search() {

        let source = allGroups

        let searchText = groupView.searchBar.text ?? ""
        var result = [Group]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for item in source {
                if (item.name?.lowercased().contains(text)) ?? false {
                    result.append(item)
                }
            }
        }

        var index = 0
        for item in source {
            if item.id == currentGroup?.id {
                currentIndex = index
                break
            }

            index += 1
        }

        groups.removeAll()
        groups.append(contentsOf: result)

        groupView.tableView.reloadData()
    }

    func actionTapToApplyButton() {
        if currentIndex != -1 {
            currentGroup = groups[currentIndex]
            applyGroupDelegate?.actionTapToApplyButton(currentGroup: currentGroup)
        }
        dismiss(animated: true, completion: nil)
    }

    func actionTapToCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension GroupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let group = groups[indexPath.row]

        let rectName = NSString(string: group.name ?? "").boundingRect(with: CGSize(width: view.frame.width - (105 + 24), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 18)!], context: nil)

        var height: CGFloat = rectName.height + 10 + 10 + 10

        if height < 80 {
            height = 80
        }

        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmployeeGroupTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none

        cell.arrowRightImgView.isHidden = true

        if currentIndex == indexPath.row {
            cell.accessoryType = .checkmark
            cell.nameLabel.textColor = Global.colorMain
        }
        else {
            cell.accessoryType = .none
            cell.nameLabel.textColor = UIColor.black
        }

        cell.bindingData(group: groups[indexPath.row])
        
        return cell
    }
}

extension GroupViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let previousCell = tableView.cellForRow(at: NSIndexPath(item: currentIndex, section: 0) as IndexPath) as? EmployeeGroupTableViewCell {
            previousCell.accessoryType = .none
            previousCell.nameLabel.textColor = UIColor.black
        }

        let currentCell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath) as! EmployeeGroupTableViewCell
        currentCell.accessoryType = .checkmark
        currentCell.nameLabel.textColor = Global.colorMain

        currentIndex = indexPath.row
    }
}

extension GroupViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No group list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension GroupViewController: UISearchBarDelegate {

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
