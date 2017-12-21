//
//  CellTryViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 2017/11/22.
//  Copyright © 2017年 hazuki. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import RealmSwift

class CellTryViewController: UIViewController,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
  
    
    //let konann = UIImage(named:"akaisann.png")
  //  let shakemii = UIImage(named:"P0cSq5sf_400×400.jpg")
    
    
    var image = ""
    var ititle:String = ""
    var date:String = ""
    
    var dateArray: [String] = Array()
    var titleArray: [String] = Array()
    var mainArray: [String] = Array()
    var picArray: [UIImage] = Array()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SVProgressHUD.show()

       

        
        tableView.estimatedRowHeight = 10//セルの高さの見積もり
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        self.tableView.register(UINib(nibName:"CustumTableCell",bundle: nil),forCellReuseIdentifier: "custumCell")
        ChangeDiary()
        
    }
    
    func MyDiary(){
        let realm = try! Realm()

        let results = realm.objects(Diary.self)
        let array = Array(results)
        
        for i in 0 ..< array.count {
        
            dateArray.append(array[i].date as String)
            titleArray.append(array[i].title)
            picArray.append(array[i].photo )
            mainArray.append(array[i].main)
        
        
        }
        
        
    }
    
    
    func ChangeDiary(){
        // databaseから画像の名前を取得
        let ref = Database.database().reference().child("283D266E-95F6-4622-BDEB-B8E20BA754E5")
        ref.observe(DataEventType.value, with: { snapshot in
            
            let postDict = snapshot.value as! [String : AnyObject]
            var names: [String] = []
            var count = 0
            for (key, value) in postDict {
                if (key == "date"){
                    self.dateArray.append(value as! String)
                }else if (key == "title"){
                    self.titleArray.append(value as! String)
                }else if (key == "downloadURL"){
                    let loadedImageData = NSData(contentsOf: NSURL(string:value as! String) as! URL)
                    self.picArray.append(UIImage(data: loadedImageData as! Data)!)
                    
                    
                    
                }else if (key == "main"){
                    self.mainArray.append(value as! String)
                }
                
                
                
            }
            
            print(self.dateArray)
            print(self.mainArray)
            print(self.titleArray)
            print(self.picArray)
            
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            
        })
        

    }
    
    
    @IBAction func testSegmentedControl(sender: UISegmentedControl) {
        
        
        //セグメント番号で条件分岐させる
        switch sender.selectedSegmentIndex {
        case 0:
            print("first")
        case 1:
            print("second")
        default:
            print("該当無し")
        }
    }
    
    @IBAction func segumentControllTap(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            print("first")
        case 1:
            print("second")
        default:
            print("該当無し")
        }    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let custumCell = tableView.dequeueReusableCell(withIdentifier: "custumCell", for: indexPath) as! CustumTableCell
        
        // セルに表示する値を設定する
        
        custumCell.imageView?.image = picArray[indexPath.row]
        custumCell.title.text = titleArray[indexPath.row]
        custumCell.date.text = dateArray[indexPath.row]
        
        
        
        
        
        
        return custumCell
    }
    
}

