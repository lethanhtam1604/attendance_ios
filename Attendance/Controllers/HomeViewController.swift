//
//  HomeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/4/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase

class HomeViewController: UIViewController {

    let homeView = HomeView()

    var groups = [Group]()
    var allGroups = [Group]()

    override func loadView() {
        view = homeView
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

        title = "HOME"

        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.emptyDataSetSource = self
        homeView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        if let userId = Auth.auth().currentUser?.uid {
            homeView.indicator.startAnimating()
            DatabaseHelper.shared.getGroups(userId: userId) {
                groups in
                self.homeView.indicator.stopAnimating()
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

        let searchText = homeView.searchBar.text ?? ""
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
        
        homeView.tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let group = groups[indexPath.row]

        let rectName = NSString(string: group.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 105, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        var height: CGFloat = rectName.height + 20

        if height <= 70 {
            height = 70
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

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        #if Admin
            let viewController = AttendanceViewController()
            viewController.group = groups[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        #else
            let realTimeStoryBoard = UIStoryboard(name: "RealTime", bundle: nil)
            if let viewController = realTimeStoryBoard.instantiateViewController(withIdentifier: "RealTimeCameraViewController") as? RealTimeCameraViewController {
                viewController.group = groups[indexPath.row]
                navigationController?.pushViewController(viewController, animated: true)
            }
        #endif
    }
}

extension HomeViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No group list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension HomeViewController: UISearchBarDelegate {

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
