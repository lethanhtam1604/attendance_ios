//
//  HomeView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/4/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class HomeView: UIView {

    var constraintsAdded = false

    let searchBar = UISearchBar()
    let tableView = UITableView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorBg
        tintColor = Global.colorMain
        addTapToDismiss()

        searchBar.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_WIDTH, height: 44)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.tintColor = Global.colorMain
        searchBar.endEditing(true)

        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.clear
                    break
                }
            }
        }

        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = Global.colorSeparator
        tableView.register(EmployeeGroupTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg

        addSubview(searchBar)
        addSubview(tableView)
        addSubview(indicator)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoMatch(.width, to: .width, of: self)
            tableView.autoPinEdge(.top, to: .bottom, of: searchBar)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)

            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
}
