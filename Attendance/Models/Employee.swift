//
//  Employee.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 6/27/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class Employee: NSObject {

    var id: String = ""
    var employeeID: String?
    var name: String?
    var avatarUrl: String?
    var dob: String?
    var gender: String?
    var groupId: String?
    var label: Int64?

    var photos = [ImageUrl]()

    var checkMark = true

    convenience init(employee: Employee) {
        self.init()
        id = employee.id
        employeeID = employee.employeeID
        name = employee.name
        avatarUrl = employee.avatarUrl
        dob = employee.dob
        gender = employee.gender
        groupId = employee.groupId
        label = employee.label

        photos = []
        photos.append(contentsOf: employee.photos)
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        id = snapshot.key
        if let snapshotValue = snapshot.value as? [String:Any] {
            name = snapshotValue["name"] as? String
            employeeID = snapshotValue["employeeID"] as? String
            avatarUrl = snapshotValue["avatarUrl"] as? String
            dob = snapshotValue["dob"] as? String
            gender = snapshotValue["gender"] as? String
            groupId = snapshotValue["groupId"] as? String
            label = snapshotValue["label"] as? Int64

            let photoAfterSnapshot = snapshot.childSnapshot(forPath: "photos")
            if let images = photoAfterSnapshot.children.allObjects as? [DataSnapshot] {
                for snap in images {
                    let imageUrl = ImageUrl(snap)
                    self.photos.append(imageUrl)
                }
            }
        }
    }

    func toAny() -> Any {

        var photoArray = [Any]()

        for image in photos {
            photoArray.append(image.toAny())
        }

        return [
            "name": name ?? "",
            "employeeID": employeeID ?? "",
            "avatarUrl": avatarUrl,
            "dob": dob ?? "",
            "gender": gender ?? "",
            "groupId": groupId ?? "",
            "label": label ?? 0,
            "photos": photoArray
        ]
    }
}
