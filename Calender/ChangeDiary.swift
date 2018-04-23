//
//diary.swift
//  Calender
//
//  Created by Hazuki♪ on 4/3/17.
//  Copyright © 2017 hazuki. All rights reserved.
//


import Foundation
import RealmSwift

class ChangeDiary: Object {
    dynamic var ID = ""
    dynamic var date = ""
    dynamic var main = ""
    dynamic var title = ""
    dynamic var photo: Data? = nil
    
    override static func primaryKey() -> String? {
        return "date"
    }
    
}

