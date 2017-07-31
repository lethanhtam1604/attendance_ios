//
//  CalendarView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/14/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarView: UIView {

    var calendar = FSCalendar()

    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorBg

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg

        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(EmployeeGroupTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        addSubview(calendar)
        addSubview(tableView)
        addSubview(indicator)

        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            calendar.autoPinEdge(toSuperviewEdge: .top)
            calendar.autoPinEdge(toSuperviewEdge: .left)
            calendar.autoPinEdge(toSuperviewEdge: .right)
            calendar.autoSetDimension(.height, toSize: 200)
            
            tableView.autoPinEdge(.top, to: .bottom, of: calendar)
            tableView.autoPinEdge(toSuperviewEdge: .bottom)
            tableView.autoPinEdge(toSuperviewEdge: .left)
            tableView.autoPinEdge(toSuperviewEdge: .right)

            indicator.autoPinEdge(.top, to: .bottom, of: calendar)
            indicator.autoPinEdge(toSuperviewEdge: .bottom)
            indicator.autoPinEdge(toSuperviewEdge: .left)
            indicator.autoPinEdge(toSuperviewEdge: .right)
        }
    }
}
