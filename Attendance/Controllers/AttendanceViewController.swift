//
//  AttendanceViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

class AttendanceViewController: UIViewController {

    let attendanceView = AttendanceView()

    var group = Group()
    var attendanceDates = [AttendanceDate]()
    var allAttendanceDates = [AttendanceDate]()

    override func loadView() {
        view = attendanceView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = group.name

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton

        attendanceView.tableView.delegate = self
        attendanceView.tableView.dataSource = self
        attendanceView.tableView.emptyDataSetSource = self
        attendanceView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        if group.id != "" {
            self.attendanceView.indicator.startAnimating()
            DatabaseHelper.shared.getAttendanceDates() {
                attendanceDates in
                self.attendanceView.indicator.stopAnimating()
                self.allAttendanceDates = attendanceDates

                DatabaseHelper.shared.observeAttendanceDate() {
                    newAttendanceDate in

                    var flag = false

                    for index in 0..<self.allAttendanceDates.count {
                        if self.allAttendanceDates[index].date == newAttendanceDate.date {
                            self.allAttendanceDates[index] = newAttendanceDate
                            flag = true
                            break
                        }
                    }

                    if !flag {
                        self.allAttendanceDates.append(newAttendanceDate)
                    }

                    self.search()
                }

                DatabaseHelper.shared.observeDeleteAttendanceDate() {
                    newAttendanceDate in

                    for index in 0..<self.allAttendanceDates.count {
                        if self.allAttendanceDates[index].date == newAttendanceDate.date {
                            self.allAttendanceDates.remove(at: index)
                            self.search()
                            break
                        }
                    }
                }
            }
        }
    }

    func search() {
        let source = allAttendanceDates

        let searchText = attendanceView.searchBar.text ?? ""
        var result = [AttendanceDate]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for item in source {
                if (item.date.lowercased().contains(text)) {
                    result.append(item)
                }
            }
        }

        attendanceDates.removeAll()
        attendanceDates.append(contentsOf: result)

        attendanceView.tableView.reloadData()
    }

    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension AttendanceViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceDates.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let attendanceDate = attendanceDates[indexPath.row]

        let rectName = NSString(string: attendanceDate.date).boundingRect(with: CGSize(width: view.frame.width - 45, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        let height: CGFloat = rectName.height + 20

        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceTableViewCell

        cell.bindingDate(attendanceDate: attendanceDates[indexPath.row])
        return cell
    }
}

extension AttendanceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = AttendanceDetailViewController()
        viewController.group = group
        viewController.attendanceDate = attendanceDates[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AttendanceViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No date list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension AttendanceViewController: UISearchBarDelegate {

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
