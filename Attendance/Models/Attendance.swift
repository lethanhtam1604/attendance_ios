//
//  Attendance.swift
//  Attendance
//
//  Created by Thanh-Tam Le on 7/6/17.
//  Copyright © 2017 citynow. All rights reserved.
//

import Firebase

class Attendance: NSObject {

    var employeeId: String = ""
    var groupId: String?
    var employee: Employee?
    var attendanceTimes = [AttendanceTime]()

    convenience init(attendance: Attendance) {
        self.init()
        employeeId = attendance.employeeId
    }

    convenience init(_ snapshot: DataSnapshot) {
        self.init()
        employeeId = snapshot.key
        if let value = snapshot.value as? [String:Any] {
            groupId = value["groupId"] as? String

            let attendanceTimeSnapshot = snapshot.childSnapshot(forPath: "attendanceTimes")
            if let times = attendanceTimeSnapshot.children.allObjects as? [DataSnapshot] {
                for snap in times {
                    let attendanceTime = AttendanceTime(snap)
                    self.attendanceTimes.append(attendanceTime)
                }
            }
        }
    }

    func toAny() -> Any {

        var attendanceTimeArray = [Any]()

        for attendanceTime in attendanceTimes {
            attendanceTimeArray.append(attendanceTime.toAny())
        }

        return [
            "groupId": groupId ?? "",
            "attendanceTimes": attendanceTimeArray
        ]
    }
}
