//
//  CalendarViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/14/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase
import DZNEmptyDataSet

class CalendarViewController: UIViewController {

    var calendarView = CalendarView()

    var groups = [Group]()
    var allGroups = [Group]()

    var attedanceDate = AttendanceDate()

    override func loadView() {
        view = calendarView
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

        title = "CALENDAR"

        calendarView.calendar.dataSource = self
        calendarView.calendar.delegate = self

        calendarView.tableView.delegate = self
        calendarView.tableView.dataSource = self
        calendarView.tableView.emptyDataSetSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    func loadData() {

        if let userId = Auth.auth().currentUser?.uid {
            calendarView.indicator.startAnimating()
            DatabaseHelper.shared.getGroups(userId: userId) {
                groups in
                self.calendarView.indicator.stopAnimating()
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

    func reloadGroup() {

        groups.removeAll()
        groups.append(contentsOf: allGroups)

        calendarView.tableView.reloadData()
    }
}

extension CalendarViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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

        cell.bindingData(group: groups[indexPath.row])

        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        attedanceDate.date = Utils.dateFormate(date: calendarView.calendar.selectedDate ?? Date()) ?? ""

        let viewController = AttendanceDetailViewController()
        viewController.group = groups[indexPath.row]
        viewController.attendanceDate = attedanceDate
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CalendarViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No attendance list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension CalendarViewController: FSCalendarDataSource {

}

extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

    }
}
