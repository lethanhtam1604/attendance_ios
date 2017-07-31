//
//  AppDelegate.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/16/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import UIKit
import IQKeyboardManager
import STPopup
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()

        //Firebase
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true

        // keyboard
        let keyboardManager = IQKeyboardManager.shared()
        keyboardManager.isEnabled = true
        keyboardManager.previousNextDisplayMode = .alwaysShow
        keyboardManager.shouldShowTextFieldPlaceholder = false
        
        //set light status bar for whole ViewController
        UIApplication.shared.statusBarStyle = .lightContent

        // set STPopupNavigationBar
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().barTintColor = Global.colorMain
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        STPopupNavigationBar.appearance().isTranslucent = false
        STPopupNavigationBar.appearance().shadowImage = UIImage()

        //init structure
        if UserDefaultManager.getInstance().getHasRunBefore() == false {
            UserDefaultManager.getInstance().setHasRunBefore(value: true)
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    self.window?.rootViewController = SplashScreenViewController()
                }
                catch _ as NSError {

                    self.window?.rootViewController = SplashScreenViewController()
                }
            }
            else {
                self.window?.rootViewController = SplashScreenViewController()
            }
        }
        else {
            self.window?.rootViewController = SplashScreenViewController()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        return true
    }

    var isInit = false

    func rotated() {

        if isInit {
            return
        }

        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            Global.SCREEN_WIDTH = UIScreen.main.bounds.size.height
            Global.SCREEN_HEIGHT = UIScreen.main.bounds.size.width
            isInit = true
        }

        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            Global.SCREEN_WIDTH = UIScreen.main.bounds.size.width
            Global.SCREEN_HEIGHT = UIScreen.main.bounds.size.height
            isInit = true
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
}

