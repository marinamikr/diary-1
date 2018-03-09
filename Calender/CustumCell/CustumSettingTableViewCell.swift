//
//  CustumSettingTableViewCell.swift
//  Calender
//
//  Created by 橋詰明宗 on 2018/03/09.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit

class CustumSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(text:String){
        label.text = text
    }
    
}
