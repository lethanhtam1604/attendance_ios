//
//  AttendanceDetailViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import SwiftOverlays

class AttendanceDetailViewController: UIViewController {

    let attendanceDetailView = AttendanceDetailView()

    var group = Group()
    var attendanceDate = AttendanceDate()
    var attendances = [Attendance]()
    var allAttendance = [Attendance]()

    var employees = [Employee]()

    override func loadView() {
        view = attendanceDetailView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        title = attendanceDate.date

        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backBarButton

        let exportBarButton = UIBarButtonItem(title: "EXPORT", style: .done, target: self, action: #selector(actionTapToExportButton))
        exportBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = exportBarButton

        attendanceDetailView.tableView.delegate = self
        attendanceDetailView.tableView.dataSource = self
        attendanceDetailView.tableView.emptyDataSetSource = self
        attendanceDetailView.searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        DatabaseHelper.shared.getEmployees(groupId: group.id) {
            employees in
            self.employees = employees
        }

        if attendanceDate.date != "" {
            self.attendanceDetailView.indicator.startAnimating()
            DatabaseHelper.shared.getAttendancesByGroup(date: attendanceDate.date, groupId: group.id) {
                attendances in
                self.attendanceDetailView.indicator.stopAnimating()
                self.allAttendance = attendances

                DatabaseHelper.shared.observeAttendances(date: self.attendanceDate.date) {
                    newAttendance in

                    var flag = false

                    for index in 0..<self.allAttendance.count {
                        if self.allAttendance[index].employeeId == newAttendance.employeeId && newAttendance.groupId == self.group.id {
                            self.allAttendance[index] = newAttendance
                            flag = true
                            break
                        }
                    }

                    if !flag && newAttendance.groupId == self.group.id {
                        self.allAttendance.append(newAttendance)
                    }

                    self.search()
                }

                DatabaseHelper.shared.observeDeleteAttendance(date: self.attendanceDate.date) {
                    newAttendance in

                    for index in 0..<self.allAttendance.count {
                        if self.allAttendance[index].employeeId == newAttendance.employeeId && newAttendance.groupId == self.group.id {
                            self.allAttendance.remove(at: index)
                            self.search()
                            break
                        }
                    }
                }
            }
        }
    }

    func search() {
        let source = allAttendance

        let searchText = attendanceDetailView.searchBar.text ?? ""
        var result = [Attendance]()

        if searchText.isEmpty {
            result.append(contentsOf: source)
        }
        else {
            let text = searchText.lowercased()

            for item in source {
                if let employee = item.employee {
                    if (employee.name?.lowercased().contains(text)) ?? false || (employee.employeeID?.lowercased().contains(text)) ?? false {
                        result.append(item)
                    }
                    else {
                        for attendanceTime in item.attendanceTimes {
                            if (attendanceTime.time?.lowercased().contains(text)) ?? false {
                                result.append(item)
                                break
                            }
                        }
                    }
                }
            }
        }

        attendances.removeAll()
        attendances.append(contentsOf: result)

        attendanceDetailView.tableView.reloadData()
    }

    func actionTapToExportButton() {

        SwiftOverlays.showBlockingWaitOverlay()

        DispatchQueue.global(qos: .default).async {
            let headers = "Id, Name, Date, Weekday, Check-in Time, Check-out Time"

            var rows = [headers]

            for attendance in self.attendances {

                for employee in self.employees {
                    if attendance.employeeId == employee.id {

                        let row = String(format: "%@, %@, %@, %@, %@, %@",
                                         employee.employeeID ?? " ",
                                         employee.name ?? " ",
                                         self.attendanceDate.date,
                                         Utils.getWeekdayFromDate(date: Utils.stringtoDate(string: self.attendanceDate.date)),
                                         attendance.attendanceTimes.count > 0 ? attendance.attendanceTimes[0].time ?? " " : " ",
                                         attendance.attendanceTimes.count > 1 ? attendance.attendanceTimes[attendance.attendanceTimes.count - 1].time ?? " " : " ")

                        rows.append(row)
                        break
                    }
                }
            }

            var result = ""
            for row in rows {
                result += row + "\n"
            }

            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let filename = (path as NSString).appendingPathComponent("Report-\(Date().iso8601).csv")
            let fileURL = URL(fileURLWithPath: filename)
            try! result.write(to: fileURL, atomically: true, encoding: .utf8)
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view

            DispatchQueue.main.sync {
                SwiftOverlays.removeAllBlockingOverlays()
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }

    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension AttendanceDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendances.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if let employeee = attendances[indexPath.row].employee {

            let rectEmployeeID = NSString(string: employeee.employeeID ?? "").boundingRect(with: CGSize(width: view.frame.width - (110 + 24), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

            let rectName = NSString(string: employeee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - (110 + 24), height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!], context: nil)

            var height: CGFloat = rectEmployeeID.height + rectName.height + 20 + 20 + 16 + 10 + 10 + 10

            if height < 110 {
                height = 110
            }

            return height
        }
        else {
            return 130
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendanceDetailTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none

        cell.bindingData(groupId: group.id, attendance: attendances[indexPath.row])

        return cell
    }
}

extension AttendanceDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension AttendanceDetailViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No attendance list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension AttendanceDetailViewController: UISearchBarDelegate {

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
