//
//  ExportGroupViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase

class ExportGroupViewController: UIViewController {

    let exportGroupView = ExportGroupView()

    var groups = [Group]()
    var allGroups = [Group]()

    override func loadView() {
        view = exportGroupView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = "EXPORT"

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(actionTapToBackButton))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        exportGroupView.tableView.delegate = self
        exportGroupView.tableView.dataSource = self
        exportGroupView.tableView.emptyDataSetSource = self
        exportGroupView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        if let userId = Auth.auth().currentUser?.uid {
            exportGroupView.indicator.startAnimating()
            DatabaseHelper.shared.getGroups(userId: userId) {
                groups in
                self.exportGroupView.indicator.stopAnimating()
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

        let searchText = exportGroupView.searchBar.text ?? ""
        var result = [Group]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for group in source {
                if (group.name?.lowercased().contains(text)) ?? false {
                    result.append(group)
                }
            }
        }

        groups.removeAll()
        groups.append(contentsOf: result)

        exportGroupView.tableView.reloadData()
    }

    func actionTapToBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension ExportGroupViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let group = groups[indexPath.row]

        let rectName = NSString(string: group.name ?? "").boundingRect(with: CGSize(width: view.frame.width - (105 + 24), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        var height: CGFloat = rectName.height + 20 + 10

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

        let group = groups[indexPath.row]
        cell.bindingData(group: group)

        return cell
    }
}

extension ExportGroupViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = ExportEmployeeViewController()
        viewController.group = groups[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ExportGroupViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No group list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension ExportGroupViewController: UISearchBarDelegate {

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
