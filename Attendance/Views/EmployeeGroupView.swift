//
//  EmployeeGroupView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/3/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit

class EmployeeGroupView: UIView {

    var constraintsAdded = false

    let searchBar = UISearchBar()
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = Global.colorBg
        tintColor = Global.colorMain
        addTapToDismiss()

        searchBar.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_WIDTH, height: 44)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search for Student"
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.white
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
        tableView.separatorStyle = .none
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()

        let p: CGFloat = 10

        collectionView.backgroundColor = UIColor.clear
        collectionView.register(EmployeeGroupCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.indicatorStyle = .white
        collectionView.contentInset = UIEdgeInsetsMake(p, p, p, p)
        collectionView.showsHorizontalScrollIndicator = false

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(p, 0, p, p)
        layout.minimumLineSpacing = p

        layout.itemSize = CGSize(width: 120, height: 150)

        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg

        addSubview(searchBar)
        addSubview(tableView)
        addSubview(collectionView)
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
            tableView.autoPinEdge(.bottom, to: .top, of: collectionView, withOffset: -10)

            collectionView.autoSetDimension(.height, toSize: 170)
            collectionView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            collectionView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            collectionView.autoPinEdge(toSuperviewMargin: .bottom)

            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
}
