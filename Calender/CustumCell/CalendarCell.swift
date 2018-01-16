//
//  CalendarCell.swift
//  Calender
//
//  Created by Hazuki♪ on 1/31/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit
import RealmSwift

class CalendarCell: UICollectionViewCell {
    var textLabel: UILabel!
    var image: UIImageView!
    let colorManager = ColorManeger()
    var colorNum:Int = 0
    var userDefaults:UserDefaults = UserDefaults.standard
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
        
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
            
        }
        
        
        print(colorNum)
        
        switch colorNum {
        case 0:
            self.layer.borderColor = UIColor(red:1.0,green:0.894, blue:0.882, alpha:1.0).cgColor
        case 1:
            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 2:
            self.layer.borderColor = UIColor(red:1.0,green:0, blue:0, alpha:1.0).cgColor
            
        case 3:
            self.layer.borderColor = UIColor(red:0,green:1.0, blue:0, alpha:1.0).cgColor
            
        case 4:
            self.layer.borderColor = UIColor(red:0,green:0, blue:1.0, alpha:1.0).cgColor
            
        case 5:
            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 6:
            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
        default:
            return
        }
        
        //self.layer.borderColor = UIColor(red:1.0,green:0.894, blue:0.882, alpha:1.0).cgColor
        self.layer.borderWidth = 0.5       //枠
        
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRect(x: 4, y: -12, width: self.frame.width, height: self.frame.height))
        textLabel.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        // Cellに追加
        self.addSubview(textLabel!)
        
        //変更点（2017/07/13）
        image = UIImageView(frame: CGRect(x: 4, y: 18, width: self.frame.width, height: self.frame.height))
        self.addSubview(image)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
            
        }
        
        
        
        switch colorNum {
        case 0:
            self.layer.borderColor = UIColor(red:1.0,green:0.894, blue:0.882, alpha:1.0).cgColor
        case 1:
            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 2:
            self.layer.borderColor = UIColor(red:1.0,green:0, blue:0, alpha:1.0).cgColor
            
        case 3:
            self.layer.borderColor = UIColor(red:0,green:1.0, blue:0, alpha:1.0).cgColor
            
        case 4:
            self.layer.borderColor = UIColor(red:0,green:0, blue:1.0, alpha:1.0).cgColor
            
        case 5:
            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 6:
            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
        default:
            return
        }

        
    }
    
}
