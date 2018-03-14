//
//  CustomSwitchTableViewCell.swift
//  Calender
//
//  Created by 橋詰明宗 on 2018/03/09.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit

class CustomSwitchTableViewCell: UITableViewCell {

  var util = Util()
     var userDefaults:UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var mySwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userDefaults.register(defaults: ["isAllUser": true])
        var isAllUser = false
        isAllUser =  userDefaults.object(forKey: "isAllUser") as! Bool
        mySwitch.isOn = isAllUser
        util.printLog(viewC: self, tag: "TAG", contents: isAllUser)
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        
        if ( sender.isOn ) {
        util.printLog(viewC: self, tag: "switch", contents: "on")
            userDefaults.set(true, forKey: "isAllUser")
            
        } else {
        util.printLog(viewC: self, tag: "switch", contents: "off")
            userDefaults.set(false, forKey: "isAllUser")
        }
        CellTryViewController.isFirst = true
    }
}
