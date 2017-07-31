//
//  NSDictionary+Extentions.swift
//  Mobo
//
//  Created by Nam Truong on 3/11/15.
//  Copyright (c) 2015 Nam Truong. All rights reserved.
//

import UIKit

extension NSDictionary  {
    func JsonStringWithPrettyPrint()-> String? {
        do{
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
        }catch{
            return nil
        }
    }
    
    func toGetParamsString() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as AnyObject).description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let percentEscapedValue = (value as AnyObject).description.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
