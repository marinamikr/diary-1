//
//diary.swift
//  Calender
//
//  Created by Hazuki♪ on 4/3/17.
//  Copyright © 2017 hazuki. All rights reserved.
//


import Foundation
import RealmSwift

class Diary: Object {
    dynamic var date = ""
    dynamic var main = ""
    dynamic var title = ""
    dynamic var photo: Data? = nil
    dynamic var changeCheck: Bool = false
    
    override static func primaryKey() -> String? {
        return "date"
    }
    
}
