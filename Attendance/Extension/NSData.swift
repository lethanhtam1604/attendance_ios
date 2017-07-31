//
//  NSData+Extentions.swift
//  iCareBenefit
//
//  Created by Nguyen Tuan on 6/17/15.
//  Copyright © 2015 Nam Truong. All rights reserved.
//

import UIKit

extension Data {
    func toNSDictionary() -> NSDictionary? {
        var jsonObj : AnyObject?
        do {
            jsonObj = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject
            return jsonObj as? NSDictionary
        } catch {
            return nil
        }
    }
    
    func toArray() -> NSArray? {
        var jsonObj : AnyObject?
        do {
            jsonObj = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject
            return jsonObj as? NSArray
        } catch {
            return nil
        }
    }
    
    
}


