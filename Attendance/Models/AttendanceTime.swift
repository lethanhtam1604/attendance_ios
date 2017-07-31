//
//  AttendanceTime.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/6/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class AttendanceTime: NSObject {

    var time: String?

    convenience init(attendanceTime: AttendanceTime) {
        self.init()
        time = attendanceTime.time
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        if let value = snapshot.value as? [String:Any] {
            time = value["time"] as? String
        }
    }

    func toAny() -> Any {
        return [
            "time": time ?? ""
        ]
    }
}
