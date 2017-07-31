//
//  String+Extentions.swift
//  iCareBenefit
//
//  Created by Nam Truong on 6/10/15.
//  Copyright © 2015 Nam Truong. All rights reserved.
//

import UIKit

extension String {

    
    func length() -> Int {
        return self.characters.count
    }
    
    func IntValue() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func contains(st:String) -> Bool {
        return NSString(string: self).contains(st)
    }
    
    func RemoveExcessSpace() -> String {
        let tempArray = self.DoSplitStringRemoveNilObject(separateString: " ")
        var output = ""
        for (index, element) in tempArray.enumerated() {
            output += element
            if index < (tempArray.count - 1) {
                output += " "
            }
        }
        return output
    }
    
    func urlDecode() ->  String {
        return self.removingPercentEncoding!
    }
    
    // Get Array From String with separateString and Remove Nil Object
    
    func DoSplitStringRemoveNilObject (separateString: String) -> [String] {
        let tempArray = NSMutableArray(array: self.components(separatedBy: separateString))
        tempArray.remove("")
        return NSArray(array: tempArray) as! [String]
    }
    
    func DoSplitCharacterOfStringRemoveNilObject (separateString: String) -> [String] {
        let tempArray = NSMutableArray(array: self.components(separatedBy: separateString))
        tempArray.remove("")
        return NSArray(array: tempArray) as! [String]
    }
    
    func toNSDictionary() -> NSDictionary? {
        if let data = self.data(using: String.Encoding.utf8) {
            return data.toNSDictionary()
        } else {
            return nil
        }
        
    }
    
    func toArray() -> NSArray? {
        if let data = self.data(using: String.Encoding.utf8) {
            return data.toArray()
        } else {
            return nil
        }
    }
    
    func toNSString() -> NSString{
        return NSString(string: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidTRN() -> Bool {
        let components = self.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        
        let PHONE_REGEX = "^((\\+)|())[0-9]{9,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: decimalString)
        return result
    }
    
    func isValidPhone() -> Bool {
        let components = self.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        
        let PHONE_REGEX = "^((\\+)|())[0-9]{3,20}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: decimalString)
        return result
    }
    
    func isValidAccount() -> Bool {
        let RegEx = "\\A\\w{1,18}\\z"
        let accountTest = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return accountTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let RegEx = ".{6,18}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  passwordTest.evaluate(with: self)
        return result
    }
    
    func isValidName() -> Bool {
        let RegEx = ".{1,50}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    func isValidAddress() -> Bool {
        let RegEx = ".{1,200}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }
    
    func isValidDescription() -> Bool {
        let RegEx = ".{1,500}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", RegEx)
        let result =  nameTest.evaluate(with: self)
        return result
    }

    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func widthWithConstrainedWidth(font: UIFont) -> CGFloat {
        return self.widthWithConstrainedWidth(font: font)
    }

    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
    
    var dateFromDateString: Date? {
        return Date.Formatter.dateFormat.date(from: self)
    }
    
    var dateFromTimeString: Date? {
        return Date.Formatter.timeFormat.date(from: self)
    }
    
    var date: Date? {
        get {
            if let d = dateFromISO8601 {
                return d
            }
            
            if let d = dateFromDateString {
                return d
            }
            
            if let d = dateFromTimeString {
                return d
            }
            
            return nil
        }
    }
}

