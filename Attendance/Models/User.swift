//
//  User.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/26/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class User: NSObject {

    var id: String = ""
    var email: String?
    var name: String?
    var phone: String?
    var thumbnailUrl: String?
    var trainingFileUrl: String?

    convenience init(user: User) {
        self.init()
        id = user.id
        name = user.name
        email = user.email
        phone = user.phone
        thumbnailUrl = user.thumbnailUrl
        trainingFileUrl = user.trainingFileUrl
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        id = snapshot.key
        if let snapshotValue = snapshot.value as? [String:Any] {
            name = snapshotValue["name"] as? String
            email = snapshotValue["email"] as? String
            phone = snapshotValue["phone"] as? String
            thumbnailUrl = snapshotValue["thumbnailUrl"] as? String
            trainingFileUrl = snapshotValue["trainingFileUrl"] as? String
        }
    }

    func toAny() -> Any {
        return [
            "name": name ?? "",
            "email": email ?? "",
            "phone": phone ?? "",
            "thumbnailUrl": thumbnailUrl ?? "",
            "trainingFileUrl": trainingFileUrl ?? ""
        ]
    }
}
