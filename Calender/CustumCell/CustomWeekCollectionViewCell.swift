//
//  CustomWeekCollectionViewCell.swift
//  Calender
//
//  Created by 橋詰明宗 on 2018/03/11.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit

class CustomWeekCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         initLayout()
    }
    
    func initLayout() {
        self.layer.borderWidth = 0.5       //枠
        //        if userDefaults.object(forKey: "COLOR") != nil {
        //            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        //
        //        }
        //        switch colorNum {
        //        case 0:
        //            self.layer.borderColor = UIColor(red:1.0,green:0.894, blue:0.882, alpha:1.0).cgColor
        //        case 1:
        //            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
        //
        //        case 2:
        //            self.layer.borderColor = UIColor(red:1.0,green:0, blue:0, alpha:1.0).cgColor
        //
        //        case 3:
        //            self.layer.borderColor = UIColor(red:0,green:1.0, blue:0, alpha:1.0).cgColor
        //
        //        case 4:
        //            self.layer.borderColor = UIColor(red:0,green:0, blue:1.0, alpha:1.0).cgColor
        //
        //        case 5:
        //            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
        //
        //        case 6:
        //            self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
        //        default:
        //            return
        //        }
        self.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:0.1).cgColor
    }


}
