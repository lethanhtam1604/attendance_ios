//
//  Array+Extentions.swift
//  Mobo
//
//  Created by hoann on 3/20/15.
//  Copyright (c) 2015 Nam Truong. All rights reserved.
//

import Foundation

extension NSArray {
    func toStringWithComponent(text:String) -> String {
        var textReturn:String = ""
        for str in self{
            if textReturn.isEmpty{
                textReturn = str as! String
            }else{
                textReturn += (text + (str as!   String))
            }
        }
        return textReturn
    }
    func JsonStringWithPrettyPrint() -> String? {
        do{
           let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
        }catch{
            return nil
        }
    }
}
