//
//  ExportEmployeeViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/7/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import STPopup
import DZNEmptyDataSet
import SwiftOverlays

class ExportEmployeeViewController: UIViewController {

    let exportEmployeeView = ExportEmployeeView()

    var group = Group()
    var employees = [Employee]()
    var allEmployees = [Employee]()

    var attendances = [Attendance]()

    override func loadView() {
        view = exportEmployeeView
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

        title = "EXPORT"

        let exportBarButton = UIBarButtonItem(title: "EXPORT", style: .done, target: self, action: #selector(actionTapToExportButton))
        exportBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = exportBarButton

        exportEmployeeView.tableView.delegate = self
        exportEmployeeView.tableView.dataSource = self
        exportEmployeeView.tableView.emptyDataSetSource = self

        let startDateAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToStartDateView))
        exportEmployeeView.startDateValueAbstractView.addGestureRecognizer(startDateAbstractViewGesture)

        let endDateAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToEndDateView))
        exportEmployeeView.endDateValueAbstractView.addGestureRecognizer(endDateAbstractViewGesture)

        let groupAbstractViewGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapToGroupView))
        exportEmployeeView.groupValueAbstractView.addGestureRecognizer(groupAbstractViewGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        loadData()
    }

    func loadData() {
        if group.id != "" {
            exportEmployeeView.indicator.startAnimating()
            DatabaseHelper.shared.getEmployees(groupId: group.id) {
                employees in
                self.exportEmployeeView.indicator.stopAnimating()
                self.allEmployees = employees

                DatabaseHelper.shared.observeEmployees() {
                    newEmployee in

                    var flag = false

                    for index in 0..<self.allEmployees.count {
                        if self.allEmployees[index].id == newEmployee.id && newEmployee.groupId == self.group.id {
                            self.allEmployees[index] = newEmployee
                            flag = true
                            break
                        }
                    }

                    if !flag && newEmployee.groupId == self.group.id {
                        self.allEmployees.append(newEmployee)
                    }

                    self.search()
                }

                DatabaseHelper.shared.observeDeleteEmployee() {
                    newEmployee in

                    for index in 0..<self.allEmployees.count {
                        if self.allEmployees[index].id == newEmployee.id && newEmployee.groupId == self.group.id {
                            self.allEmployees.remove(at: index)
                            self.search()
                            break
                        }
                    }
                }
            }
        }
    }

    func search() {
        let source = allEmployees

        employees.removeAll()
        employees.append(contentsOf: source)

        exportEmployeeView.tableView.reloadData()
    }

    func actionTapToExportButton() {

        if exportEmployeeView.startDateValueField.text == "" {
            Utils.showAlert(title: "Error", message: "Start Date can not be empty!", viewController: self)
            return
        }

        if exportEmployeeView.endDateValueField.text == "" {
            Utils.showAlert(title: "Error", message: "End Date can not be empty!", viewController: self)
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd-MM-yyyy"

        var startDate = dateFormatter.date(from: exportEmployeeView.startDateValueField.text!)

        let endDate = dateFormatter.date(from: exportEmployeeView.endDateValueField.text!)

        if (startDate?.isGreaterThanDate(dateToCompare: endDate!))! {
            Utils.showAlert(title: "Error", message: "End Date should be greater than Start Date", viewController: self)
            return
        }

        SwiftOverlays.showBlockingWaitOverlay()

        var result = ""

        let headers = "Id, Name, Date, Weekday, Check-in Time, Check-out Time"
        var rows = [headers]

        DispatchQueue(label: "com.attendance").sync {

            while (startDate?.isLessThanDate(dateToCompare: endDate!))! || (startDate?.equalToDate(dateToCompare: endDate!))! {
                let date = startDate


                DatabaseHelper.shared.getAttendances(date: Utils.dateFormate(date: date!)!) {
                    attendances in
                    self.attendances = attendances



                    for attendance in attendances {

                        for employee in self.employees {
                            if attendance.employeeId == employee.id && employee.checkMark {
                                let row = String(format: "%@, %@, %@, %@, %@, %@",
                                                 employee.employeeID ?? " ",
                                                 employee.name ?? " ",
                                                 Utils.dateFormate(date: date!)!,
                                                 Utils.getWeekdayFromDate(date: date!),
                                                 attendance.attendanceTimes.count > 0 ? attendance.attendanceTimes[0].time ?? " " : " ",
                                                 attendance.attendanceTimes.count > 1
                                                    ? attendance.attendanceTimes[attendance.attendanceTimes.count - 1].time ?? " " : " ")
                                
                                rows.append(row)
                                break
                            }
                        }
                    }

                    if (date?.equalToDate(dateToCompare: endDate!))! {

                        for row in rows {
                            result += row + "\n"
                        }

                        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                        let filename = (path as NSString).appendingPathComponent("Report-\(Date().iso8601).csv")
                        let fileURL = URL(fileURLWithPath: filename)
                        try! result.write(to: fileURL, atomically: true, encoding: .utf8)
                        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                        activityVC.popoverPresentationController?.sourceView = self.view

                        SwiftOverlays.removeAllBlockingOverlays()
                        self.present(activityVC, animated: true, completion: nil)
                    }
                }

                let dayComponenet = NSDateComponents()
                dayComponenet.day = 1

                let calendar = NSCalendar(identifier: .ISO8601)
                let nextDate = calendar?.date(byAdding: dayComponenet as DateComponents, to: date!, options: [])

                startDate = nextDate
            }

        }
    }

    var fromDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd-MM-yyyy"

            if fromDate != nil {
                self.exportEmployeeView.startDateValueField.text = dateFormatter.string(from: fromDate! as Date)
            }
        }
    }

    var endDate : NSDate? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd-MM-yyyy"

            if endDate != nil {
                self.exportEmployeeView.endDateValueField.text = dateFormatter.string(from: endDate! as Date)
            }
        }
    }

    func actionTapToStartDateView() {
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

    func actionTapToEndDateView() {
        var date = NSDate()

        if(endDate != nil) {
            date = endDate!
        }

        var datePickerViewController : UIViewController!
        datePickerViewController = AIDatePickerController.picker(with: date as Date!, selectedBlock: {
            newDate in
            self.endDate = newDate as NSDate?
            datePickerViewController.dismiss(animated: true, completion: nil)
        }, cancel: {
            datePickerViewController.dismiss(animated: true, completion: nil)
        }) as! UIViewController

        datePickerViewController.view.tintColor = Global.colorMain

        present(datePickerViewController, animated: true, completion: nil)
    }

    func actionTapToGroupView() {
        let viewController = GroupViewController()
        viewController.currentGroup = group
        viewController.applyGroupDelegate = self
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true, completion: nil)
    }
}

extension ExportEmployeeViewController: ApplyGroupDelegate {

    func actionTapToApplyButton(currentGroup: Group?) {

        if let group = currentGroup {
            self.group = group
            exportEmployeeView.groupValueField.text = group.name
        }
    }
}

extension ExportEmployeeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let employee = employees[indexPath.row]

        let rectName = NSString(string: employee.name ?? "").boundingRect(with: CGSize(width: view.frame.width - 105, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont(name: "OpenSans-bold", size: 18)!], context: nil)

        var height: CGFloat = rectName.height + 20

        if height <= 70 {
            height = 70
        }

        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChosenEmployeeTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero

        let employee = employees[indexPath.row]

        if employee.checkMark {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        cell.bindingData(employee: employee)

        return cell
    }
}

extension ExportEmployeeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath) as! ChosenEmployeeTableViewCell

        let employee = employees[indexPath.row]
        
        if employee.checkMark {
            employee.checkMark = false
            cell.accessoryType = .none
        }
        else {
            employee.checkMark = true
            cell.accessoryType = .checkmark
        }
    }
}

extension ExportEmployeeViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No student list found"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
                     NSForegroundColorAttributeName: Global.colorSelected]
        return NSAttributedString(string: text, attributes: attrs)
    }
}
