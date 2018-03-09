//
//  Util.swift
//  Calender
//
//  Created by 橋詰明宗 on 2018/03/09.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import Foundation

class Util: NSObject {
    
    func  printLog(viewC : Any ,tag : String, contents:Any){
        print(String(describing: viewC.self) + "【" + tag + "】", terminator: "")
        print(contents)
    }
}

