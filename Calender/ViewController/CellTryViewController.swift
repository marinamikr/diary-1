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
    var myDiaryCount: Int = 0
    
    var image = ""
    var ititle:String = ""
    var date:String = ""
    
    var dateArray: [String] = Array()
    var titleArray: [String] = Array()
    var mainArray: [String] = Array()
    var picArray: [UIImage] = Array()
    var nameArray: [String] = Array()
    
    var userDefaults:UserDefaults = UserDefaults.standard
    var ref :DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tableView.estimatedRowHeight = 10//セルの高さの見積もり
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        self.tableView.register(UINib(nibName:"CustumTableCell",bundle: nil),forCellReuseIdentifier: "custumTableCell")
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //changeDiary()
        changeAllUserDiary()
        
    }
    
    //端末内のある日記を取得する処理
    func myDiary(){
        //配列の要素を全て削除
        dateArray.removeAll()
        titleArray.removeAll()
        mainArray.removeAll()
        picArray.removeAll()
        
        //Realmオブジェクトの取得
        let realm = try! Realm()
        //Realmに保存されている全ての情報を取得
        let results = Array(realm.objects(Diary.self))
        //Realmに保存されている要素の数だけfor文を回して配列に追加
        for i in 0 ..< results.count {
            
            dateArray.append(results[i].date)
            titleArray.append(results[i].title)
            
            
            if results[i].photo != nil{
                picArray.append(UIImage(data:results[i].photo! )!)
            }else{
                picArray.append(UIImage())
            }
            
            mainArray.append(results[i].main)
            
            //tableViewのリロード
            self.tableView.reloadData()
        }
    }
    
    //サーバー上の日記を取得する処理
    func changeDiary(){
        
        //配列の要素を全て削除
        dateArray.removeAll()
        titleArray.removeAll()
        mainArray.removeAll()
        picArray.removeAll()
        
        //ロード中のダイアログを表示する
        SVProgressHUD.show()
        
        //FIXME:
        var users = userDefaults.object(forKey: "users") as! [[String:String]]
        print("asdfghjkl")
        print(myDiaryCount)
        print(users)
        
        if myDiaryCount <= users.count{
            for i in 0 ..< myDiaryCount{
                let random = arc4random_uniform(UInt32(users.count))
                
                
                let user = users[Int(random)]
                print(user)
            }
        } else {
            for user in users {
                
                // databaseから画像の名前を取得
                ref.child(user["userID"]!).observe(DataEventType.value, with: { snapshot in
                    
                    let postDict = snapshot.value as! [String : AnyObject]
                    print(postDict)
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
                    self.nameArray.append(user["userName"]!)
                    
                    //tableViewのリロード
                    self.tableView.reloadData()
                    
                })
                
                SVProgressHUD.dismiss()
                
                
            }
        }
        
        
        //ロード中のダイアログを消去する
        //tableViewのリロード
        //self.tableView.reloadData()
    }
    
    //サーバー上の日記を取得する処理
    func changeAllUserDiary(){
        
        //全ユーザー情報を取得
        let allUserArray:Array<Dictionary<String,String>> = userDefaults.array(forKey: "allUser") as! Array<Dictionary<String,String>>
        print(allUserArray)
        //自分の日記数を取得
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let lef = Database.database().reference()
        lef.child(uuid).observe(.value, with:{ (snapshot)  in
            print("hoge")
            print(snapshot.childrenCount)
            print(snapshot)
            self.myDiaryCount = Int(snapshot.childrenCount)
            
            print(self.myDiaryCount)
            print(allUserArray.count)
            
            
            
            
            var userNumber:Int = 0
            var otherUserArray:Array<Dictionary<String,String>> = allUserArray

            print("asdfgh")
            print(otherUserArray.count)
            var position = 0
            
            for i in 0 ..< otherUserArray.count{
                print(i)
                let dic = otherUserArray[i]
                let ID = dic["user"]
                if ID == uuid{
                 position = i
                }
            }
            otherUserArray.remove(at: position)
            
            print(uuid)
            print(otherUserArray)
            
            
            if self.myDiaryCount <= otherUserArray.count{
                print("こっち")
                userNumber = self.myDiaryCount
            }else{
                userNumber = otherUserArray.count
            }
            
            
            print("こっち")
            for i in 0 ..< userNumber{
                print("fuga")
                
                let randomNumber:Int = Int(arc4random_uniform(UInt32(otherUserArray.count)))
                let targetUser:Dictionary<String,String> = otherUserArray[randomNumber]
                print(randomNumber)
                print(targetUser["user"]!)
                
                self.ref.child(targetUser["user"]!).observe(DataEventType.value, with: { snapshot in
                    let randomDiaryNumber:Int = Int(arc4random_uniform(UInt32(snapshot.childrenCount)))
                    print("hogehoge")
                    print(snapshot.childrenCount)
                    print(randomDiaryNumber)
                    print(targetUser["user"]!)
                    
                    let targetSnapshot = snapshot.children.allObjects[randomDiaryNumber] as! DataSnapshot
                    
                    let targetDictionary = targetSnapshot.value as! [String : AnyObject]
                    print(targetDictionary)
                    for (key, value) in targetDictionary {
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
                    print(self.titleArray)
                    print(self.mainArray)
                    
                    self.tableView.reloadData()
                    
                    SVProgressHUD.dismiss()
                    
                    
                })
                
            }
            
        })
        
        
        //配列の要素を全て削除
        dateArray.removeAll()
        titleArray.removeAll()
        mainArray.removeAll()
        picArray.removeAll()
        
        //ロード中のダイアログを表示する
        SVProgressHUD.show()
        
        
        
        
        
        //ロード中のダイアログを消去する
        //tableViewのリロード
        //self.tableView.reloadData()
    }
    
    
    @IBAction func segumentControllTap(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            print("first")
            changeAllUserDiary()
        case 1:
            print("second")
            myDiary()
            
        default:
            print("該当無し")
        }
        
        //ロード中のダイアログを消去する
        SVProgressHUD.dismiss()
        //tableViewのリロード
        self.tableView.reloadData()
    }
    
    
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dateArray.count)
        return dateArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let custumCell = tableView.dequeueReusableCell(withIdentifier: "custumTableCell", for: indexPath) as! CustumTableCell
        // セルに表示する値を設定する
        custumCell.pic.image = picArray[indexPath.row]
        custumCell.title.text = titleArray[indexPath.row]
        custumCell.date.text = dateArray[indexPath.row]
        // custumCell.userName.text = nameArray[indexPath.row]
        
        print(picArray[indexPath.row])
        print(titleArray[indexPath.row])
        
        return custumCell
    }
}



