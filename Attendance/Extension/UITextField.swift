//
//  UITextField.swift
//  RSS
//
//  Created by Thanh-Tam Le on 6/8/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit

extension UITextField {
    func makeDatePickerWithDoneButton() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        self.inputView = datePicker
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        text = sender.date.dateString
    }
    
    func makeTimePickerWithDoneButton() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(handleTimePicker), for: .valueChanged)
        self.inputView = datePicker
    }
    
    func handleTimePicker(_ sender: UIDatePicker) {
        text = sender.date.timeString
    }
    
    func TRNFormat(string: String, range: NSRange) -> Bool {
        
        let newString = (self.text! as NSString).replacingCharacters(in: range, with: string)
     
        
        let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        
        if length > 9 {
            return false
        }
        
        var index = 0 as Int
        let formattedString = NSMutableString()
  
        if (length - index) > 3
        {
            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", areaCode)
            index += 3
        }
        if length - index > 3
        {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        self.text = formattedString as String
        
        return false
    }
    
    func phoneNumberFormat(string: String, range: NSRange) -> Bool {
        
        let newString = (self.text! as NSString).replacingCharacters(in: range, with: string)
        
        
        let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "") as NSString
        let length = decimalString.length
        
        if length > 7 {
            return false
        }
        
        var index = 0 as Int
        let formattedString = NSMutableString()
        
//        if (length - index) > 3
//        {
//            let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
//            formattedString.appendFormat("%@-", areaCode)
//            index += 3
//        }
        if length - index > 3
        {
            let prefix = decimalString.substring(with: NSMakeRange(index, 3))
            formattedString.appendFormat("%@-", prefix)
            index += 3
        }
        
        let remainder = decimalString.substring(from: index)
        formattedString.append(remainder)
        self.text = formattedString as String
        
        return false
    }

}
