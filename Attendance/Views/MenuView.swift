//
//  MenuView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class MenuView: UIView {

    var constraintsAdded = false

    let tableView = UITableView()

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor.white

        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(MenuHeaderView.self, forCellReuseIdentifier: "header")
        tableView.tableFooterView = UIView()

        addSubview(tableView)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            tableView.autoPinEdgesToSuperviewEdges()
        }
    }
}
