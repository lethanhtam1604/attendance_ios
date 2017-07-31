//
//  AddEmployeeView.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/30/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DropDown

class AddEmployeeView: UIView {

    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    var constraintsAdded = false

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor.clear
        tintColor = Global.colorMain
        addTapToDismiss()

        let p: CGFloat = 5

        collectionView.backgroundColor = Global.colorBg
        collectionView.register(EmployeHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.indicatorStyle = .white

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(p, p, p, p)
        layout.minimumLineSpacing = 0

        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 4 - p * 2
        layout.itemSize = CGSize(width: width, height: width)
        
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = Global.colorBg

        addSubview(collectionView)
        addSubview(indicator)
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !constraintsAdded {
            constraintsAdded = true

            collectionView.autoAlignAxis(toSuperviewAxis: .vertical)
            collectionView.autoMatch(.width, to: .width, of: self)
            collectionView.autoPinEdge(toSuperviewMargin: .top)
            collectionView.autoPinEdge(toSuperviewMargin: .bottom)

            indicator.autoPinEdgesToSuperviewEdges()
        }
    }
}
