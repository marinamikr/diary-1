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
    
    @IBOutlet weak var mySwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if ( sender.isOn ) {
        util.printLog(viewC: self, tag: "switch", contents: "on")
        } else {
        util.printLog(viewC: self, tag: "switch", contents: "off")
        }
    }
}
