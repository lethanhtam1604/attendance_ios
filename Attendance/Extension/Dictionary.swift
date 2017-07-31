//
//  Dictionary.swift
//  Education Platform
//
//  Created by Duy Cao on 12/18/16.
//  Copyright © 2016 Duy Cao. All rights reserved.
//

import UIKit

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String)
            let percentEscapedValue = (value as AnyObject).description as String
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        if parameterArray.count == 0 { return "" }
        return "?"+parameterArray.joined(separator: "&")
    }
}
