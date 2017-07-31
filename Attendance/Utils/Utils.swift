//
//  Utils.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/17/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit
import SystemConfiguration
import UserNotifications

protocol AlertDelegate {
    func actionTapToNoButton()
    func actionTapToYesButton()
}

class Utils {
    
    static func generateUUIDString() -> String {
        var st = UUID().uuidString.components(separatedBy: " ").last!.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        st = st.replacingOccurrences(of: "-", with: "", options: .literal, range: nil).lowercased()
        return st
    }
    
    static func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertAction(title: String, message: String, viewController: UIViewController, alertDelegate: AlertDelegate?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "NO", style: .default) {
            UIAlertAction in
            if alertDelegate != nil {
                alertDelegate?.actionTapToNoButton()
            }
        }
        let okAction = UIAlertAction(title: "YES", style: .default) {
            UIAlertAction in
            if alertDelegate != nil {
                alertDelegate?.actionTapToYesButton()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertMessageAction(title: String, message: String, viewController: UIViewController, alertDelegate: AlertDelegate?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default) {
            UIAlertAction in
            if alertDelegate != nil {
                alertDelegate?.actionTapToYesButton()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func stringtoDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateStyle = .medium
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateFormat =  "dd-MM-yyyy"

        let date = dateFormatter.date(from: string)
        return date!
    }

    static func dateFormate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateStyle = .medium
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateFormat = "dd-MM-yyyy"

        let result = dateFormatter.string(from: date)

        return result
    }

    static func getWeekdayFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE"

        let dayOfWeekString = dateFormatter.string(from: date)

        return dayOfWeekString
    }

    static func getCurrentDate() -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateStyle = .medium
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let result = dateFormatter.string(from: date)
        
        return result
    }

    static func getCurrentTime() -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateStyle = .medium
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        dateFormatter.dateFormat = "HH:mm"

        let result = dateFormatter.string(from: date)

        return result
    }
    
    static func getRandomName() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale as Locale!
        return "\(dateFormatter.string(from: date as Date))"
    }
    
    static func getRandomColor() -> UIColor{
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    static func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    static func setBadgeIndicator(badgeCount: Int) {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
        }
        else{
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = badgeCount
        
//        MainViewController.jobViewController.tabBarItem.badgeValue = (badgeCount == 0) ? nil : "\(badgeCount)"
    }
    
    static func setBadgeIndicatorForStaff(badgeCount: Int) {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
        }
        else{
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = badgeCount
        
//        MainViewController.invitationViewController.tabBarItem.badgeValue = (badgeCount == 0) ? nil : "\(badgeCount)"
    }

    static func faceModelFileURL(fileName: String) -> URL {
        let paths: [Any] = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths.last as! URL
        let modelURL = documentsURL.appendingPathComponent(fileName)

        return modelURL
    }

    static func readFile(pathFile: String) -> Data? {
        let file: FileHandle? = FileHandle(forReadingAtPath: pathFile)

        if file != nil {
            let data = file?.readDataToEndOfFile()
            file?.closeFile()

            return data
        }
        else {
            return nil
        }
    }

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
