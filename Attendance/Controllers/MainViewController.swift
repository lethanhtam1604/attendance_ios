//
//  MainViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/16/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MainViewController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {

    static var realTimeCameraViewController = RealTimeCameraViewController()
    static var calendarViewController = CalendarViewController()
    static var employeeGroupViewController = EmployeeGroupViewController()
    static var exportEmployeeViewController = ExportEmployeeViewController()
    static var settingViewController = SettingViewController()

    var homeImage: UIImage!
    var groupImage: UIImage!
    var trainingImage: UIImage!
    var settingImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tintColor = Global.colorMain
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundImage = UIImage()
        tabBar.isTranslucent = false

        let attributesNormal = [NSForegroundColorAttributeName: Global.colorGray, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]
        let attributesSelected = [NSForegroundColorAttributeName: Global.colorMain, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 10)!]

        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)


        let realTimeStoryBoard = UIStoryboard(name: "RealTime", bundle: nil)
        if let viewController = realTimeStoryBoard.instantiateViewController(withIdentifier: "RealTimeCameraViewController") as? RealTimeCameraViewController {
            MainViewController.realTimeCameraViewController = viewController
        }

        MainViewController.calendarViewController = CalendarViewController()
        MainViewController.employeeGroupViewController = EmployeeGroupViewController()
        MainViewController.exportEmployeeViewController = ExportEmployeeViewController()
        MainViewController.settingViewController = SettingViewController()

        homeImage = UIImage(named: "calendar-check")
        groupImage = UIImage(named: "Staff")
        trainingImage = UIImage(named: "ic_data_usage")
        settingImage = UIImage(named: "Setting")

        #if User
            let homeBarItem = UITabBarItem(title: "CAMERA", image: homeImage, tag: 1)
            MainViewController.realTimeCameraViewController.tabBarItem = homeBarItem
            let nc1 = UINavigationController(rootViewController: MainViewController.realTimeCameraViewController)

            let settingBarItem = UITabBarItem(title: "SETTINGS", image: settingImage, tag: 4)
            MainViewController.settingViewController.tabBarItem = settingBarItem
            let nc2 = UINavigationController(rootViewController: MainViewController.settingViewController)

            self.viewControllers = [nc1, nc2]
        #else
            let homeBarItem = UITabBarItem(title: "CALENDAR", image: homeImage, tag: 1)
            MainViewController.calendarViewController.tabBarItem = homeBarItem
            let nc1 = UINavigationController(rootViewController: MainViewController.calendarViewController)

            let groupBarItem = UITabBarItem(title: "STUDENTS/GROUPS", image: groupImage, tag: 2)
            MainViewController.employeeGroupViewController.tabBarItem = groupBarItem
            let nc2 = UINavigationController(rootViewController: MainViewController.employeeGroupViewController)

            let trainingBarItem = UITabBarItem(title: "EXPORT", image: trainingImage, tag: 3)
            MainViewController.exportEmployeeViewController.tabBarItem = trainingBarItem
            let nc3 = UINavigationController(rootViewController: MainViewController.exportEmployeeViewController)

            let settingBarItem = UITabBarItem(title: "SETTINGS", image: settingImage, tag: 4)
            MainViewController.settingViewController.tabBarItem = settingBarItem
            let nc4 = UINavigationController(rootViewController: MainViewController.settingViewController)
            
            self.viewControllers = [nc1, nc2, nc3, nc4]
        #endif
    }
}
