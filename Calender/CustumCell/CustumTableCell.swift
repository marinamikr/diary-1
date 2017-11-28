//
//  CustumTableCell.swift
//  Calender
//
//  Created by Hazuki♪ on 2017/11/28.
//  Copyright © 2017年 hazuki. All rights reserved.
//

import UIKit

class CustumTableCell: UITableViewCell {

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
