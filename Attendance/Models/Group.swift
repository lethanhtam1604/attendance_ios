//
//  Group.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/5/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class Group: NSObject {

    var id: String = ""
    var name: String?
    var imageUrl: String?

    convenience init(group: Group) {
        self.init()
        id = group.id
        name = group.name
        imageUrl = group.imageUrl
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        id = snapshot.key
        if let snapshotValue = snapshot.value as? [String:Any] {
            name = snapshotValue["name"] as? String
            imageUrl = snapshotValue["imageUrl"] as? String
        }
    }

    func toAny() -> Any {
        return [
            "name": name ?? "",
            "imageUrl": imageUrl ?? ""
        ]
    }
}
