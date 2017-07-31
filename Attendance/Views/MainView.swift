//
//  MainView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/16/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class MainView: UIView {

    var constraintsAdded = false

    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorBg

        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = Global.colorSeparator
        tableView.register(EmployeeGroupTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg

        addSubview(tableView)
        addSubview(indicator)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            tableView.autoPinEdgesToSuperviewEdges()
            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
}
