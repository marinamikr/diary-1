//
//  User.swift
//  Calender
//
//  Created by Hazuki♪ on 2018/02/20.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var userID:String = ""
    dynamic var userName:String = ""
    override static func primaryKey() -> String? {
        return "userID"
    }
}

