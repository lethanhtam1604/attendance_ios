//
//  ImageUrl.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/19/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class ImageUrl: NSObject {

    var image: String?

    convenience init(imageUrl: ImageUrl) {
        self.init()
        image = imageUrl.image
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            image = value["imageUrl"] as? String
        }
    }

    func toAny() -> Any {
        return [
            "imageUrl": image ?? ""
        ]
    }
}
