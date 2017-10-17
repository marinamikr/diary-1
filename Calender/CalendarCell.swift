//
//  CalendarCell.swift
//  Calender
//
//  Created by Hazuki♪ on 1/31/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit


class CalendarCell: UICollectionViewCell {
   var textLabel: UILabel!
    var image: UIImageView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.borderColor = UIColor(red:1.0,green:0.894, blue:0.882, alpha:1.0).cgColor
        self.layer.borderWidth = 0.5       //枠
       
        var colorNum:Int = 0
        let colorManager = ColorManeger()
        var userDefaults:UserDefaults = UserDefaults.standard

        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }

        // UILabelを生成
        textLabel = UILabel(frame: CGRect(x: 4, y: -12, width: self.frame.width, height: self.frame.height))
        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        
        // Cellに追加
        self.addSubview(textLabel!)
        
        image = UIImageView(frame: CGRect(x: 4, y: 18, width: self.frame.width, height: self.frame.height))
        self.addSubview(image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
}
