//
//  UserDefaultManager.swift
//  MyLifeMatters
//
//  Created by Thanh-Tam Le on 11/29/16.
//  Copyright © 2016 Thanh-Tam Le. All rights reserved.
//

import UIKit

class UserDefaultManager {

    private static var sharedInstance: UserDefaultManager!
    
    private let defaults = UserDefaults.standard

    private let isInitApp = "isInitApp"
    private let userType = "userType"
    private let jobStatusFilter = "jobStatusFilter"
    private let assignmentStatusFilter = "assignmentStatusFilter"
    private let currentPasswordUser = "currentPasswordUser"
    private let hasRunBefore = "hasRunBefore"
    private let isRunApp = "isRunApp"
    
    static func getInstance() -> UserDefaultManager {
        if(sharedInstance == nil) {
            sharedInstance = UserDefaultManager()
        }
        return sharedInstance
    }
    
    private init() {
        
    }

    func setIsInitApp(value: Bool) {
        defaults.set(value, forKey: isInitApp)
        defaults.synchronize()
    }

    func getIsInitApp() -> Bool {
        return defaults.bool(forKey: isInitApp)
    }

    func setUserType(value: Bool) {
        defaults.set(value, forKey: userType)
        defaults.synchronize()
    }
    
    func getUserType() -> Bool {
        return defaults.bool(forKey: userType)
    }
    
    func setJobStatusFilter(value: Int) {
        defaults.set(value, forKey: jobStatusFilter)
        defaults.synchronize()
    }
    
    func getJobStatusFilter() -> Int {
        return defaults.integer(forKey: jobStatusFilter)
    }
    
    func setAssignmentStatusFilter(value: Int) {
        defaults.set(value, forKey: assignmentStatusFilter)
        defaults.synchronize()
    }
    
    func getAssignmentStatusFilter() -> Int {
        return defaults.integer(forKey: assignmentStatusFilter)
    }
    
    func setCurrentPasswordUser(value: String) {
        defaults.set(value, forKey: currentPasswordUser)
        defaults.synchronize()
    }
    
    func getCurrentPasswordUser() -> String? {
        return defaults.string(forKey: currentPasswordUser)
    }
    
    func setHasRunBefore(value: Bool) {
        defaults.set(value, forKey: hasRunBefore)
        defaults.synchronize()
    }
    
    func getHasRunBefore() -> Bool? {
        return defaults.bool(forKey: hasRunBefore)
    }
    
    func setIsRunApp(value: Bool) {
        defaults.set(value, forKey: isRunApp)
        defaults.synchronize()
    }
    
    func getIsRunApp() -> Bool? {
        return defaults.bool(forKey: isRunApp)
    }
}
