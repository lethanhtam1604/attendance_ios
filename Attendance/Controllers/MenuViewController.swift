//
//  MenuViewController.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    let menuView = MenuView()

    var menus = [Menu]()
    var user = User()

    override func loadView() {
        view = menuView
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.tableView.delegate = self
        menuView.tableView.dataSource = self

        loadData()
    }

    func loadData() {

        user.name = "Phan Thi Ngoc"
        user.thumbnailUrl = ""

        var menu = Menu()
        menu.id = 0
        menu.title = "Home"
        menu.icon = UIImage(named: "ic_home")
        menus.append(menu)

        menu = Menu()
        menu.id = 1
        menu.title = "Employee"
        menu.icon = UIImage(named: "ic_list")
        menus.append(menu)

        menu = Menu()
        menu.id = 2
        menu.title = "Export"
        menu.icon = UIImage(named: "ic_import_export")
        menus.append(menu)

        menu = Menu()
        menu.id = 3
        menu.title = "Logout"
        menu.icon = UIImage(named: "ic_exit_to_app")
        menus.append(menu)

        menuView.tableView.reloadData()
    }
}

extension MenuViewController: AlertDelegate {

    func actionTapToYesButton() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let nav = UINavigationController(rootViewController: LoginViewController())
                appDelegate.window?.rootViewController = nav
            }
            catch let error as NSError {
                Utils.showAlert(title: "Logout", message: error.localizedDescription, viewController: self)
            }
        }
        else {
            Utils.showAlert(title: "Logout", message: "Logout error. Please try again!", viewController: self)
        }
    }

    func actionTapToNoButton() {

    }
}

extension MenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! MenuHeaderView

        cell.contentView.backgroundColor = Global.colorMain
        cell.bindingData(user: user)

        cell.layoutIfNeeded()
        cell.setNeedsLayout()

        return cell.contentView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.bindingData(menu: menus[indexPath.row])
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        self.revealViewController().rightRevealToggle(animated: true)

        if menus[indexPath.row].id == 0 {
            let viewController = MainViewController()
            let nav = UINavigationController(rootViewController: viewController)
            revealViewController()?.setFront(nav, animated: true)
        }
        else if menus[indexPath.row].id == 1 {
            let viewController = EmployeeGroupViewController()
            let nav = UINavigationController(rootViewController: viewController)
            revealViewController()?.setFront(nav, animated: true)
        }
        else if menus[indexPath.row].id == 2 {

        }
        else {
            Utils.showAlertAction(title: "Logout", message: "Are you sure want to logout?", viewController: self, alertDelegate: self)
        }
    }
}
