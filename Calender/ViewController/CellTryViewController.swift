//
//  CellTryViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 2017/11/22.
//  Copyright © 2017年 hazuki. All rights reserved.
//

import UIKit

class CellTryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let konann = UIImage(named:"akaisann.png")
    let shakemii = UIImage(named:"P0cSq5sf_400×400.jpg")
    
 
    let image = ""
    var ititle:String = ""
    var date:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib(nibName:"CustumTableCell",bundle: nil),forCellReuseIdentifier: "custumCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let custumCell = tableView.dequeueReusableCell(withIdentifier: "custumCell", for: indexPath) as! CustumTableCell
        
        // セルに表示する値を設定する
        
        custumCell.pic.image = UIImage(named: "akaisann.png")
        custumCell.title.text = "schoolnow"
        custumCell.date.text = "20171128"

    
        
        
         
        
        return custumCell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
   
}
