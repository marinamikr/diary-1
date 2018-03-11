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

class CellTryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var myDiaryCount: Int = 0
    var util = Util()
    
    var image = ""
    var ititle:String = ""
    var date:String = ""
    
    var dateArray: [String] = Array()
    var titleArray: [String] = Array()
    var mainArray: [String] = Array()
    var picArray: [UIImage] = Array()
    
    var dateArrayFireBase: [String] = Array()
    var titleArrayFireBase: [String] = Array()
    var mainArrayFireBase: [String] = Array()
    var picArrayFireBase: [UIImage] = Array()
    
    var isMyDiary = true
    
    
    
    var userDefaults:UserDefaults = UserDefaults.standard
    var ref :DatabaseReference!
    
    static var isFirst:Bool = false
    
    var indexPathNumber:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tableView.estimatedRowHeight = 10//セルの高さの見積もり
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib(nibName:"CustumTableCell",bundle: nil),forCellReuseIdentifier: "custumTableCell")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //changeDiary()
        if CellTryViewController.isFirst == true{
            CellTryViewController.isFirst = false
            userDefaults.register(defaults: ["isAllUser": false])
            let  isAllUser = userDefaults.object(forKey: "isAllUser") as! Bool
            if isAllUser == true{
                changeAllUserDiary()
                //myDiary()
            }else{
                changeFriendeDiary()
                //myDiary()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userDefaults.set(dateArray, forKey: "dateArray")
        userDefaults.set(titleArray, forKey: "titleArray")
        userDefaults.set(mainArray, forKey: "mainArray")
        
        var picDataArray = Array<NSData>()
        
        for i in 0 ..< picArray.count{
            picDataArray.append(UIImageJPEGRepresentation(picArray[i], 0.8) as! NSData)
        }
        
        userDefaults.set(picDataArray, forKey: "picDataArray")
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
    func changeAllUserDiary(){
        
        self.util.printLog(viewC: self, tag: "取得条件", contents: "全ユーザー")
        //配列の要素を全て削除
        dateArray.removeAll()
        titleArray.removeAll()
        mainArray.removeAll()
        picArray.removeAll()
        
         userDefaults.register(defaults: ["dateArray": Array<String>()])
         userDefaults.register(defaults: ["titleArray": Array<String>()])
         userDefaults.register(defaults: ["mainArray": Array<String>()])
         userDefaults.register(defaults: ["picDataArray": Array<UIImage>()])
        dateArray = userDefaults.object(forKey: "dateArray") as! Array<String>
        titleArray  = userDefaults.object(forKey: "titleArray") as! Array<String>
        mainArray  = userDefaults.object(forKey: "mainArray") as! Array<String>
        
        let picDataArray :Array<NSData> = userDefaults.object(forKey: "picDataArray") as! Array<NSData>
        
        for i in 0 ..< picDataArray.count {
            picArray.append(UIImage(data:picDataArray[i] as Data)!)
        }
        
        //ロード中のダイアログを表示する
        SVProgressHUD.show()
        
        //全ユーザー情報を取得
        let allUserArray:Array<Dictionary<String,String>> = userDefaults.array(forKey: "allUser") as! Array<Dictionary<String,String>>
        util.printLog(viewC: self, tag: "全ユーザー情報", contents: allUserArray)
        
        //自分の日記数を取得
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let lef = Database.database().reference()
        lef.child(uuid).observe(.value, with:{ (snapshot)  in
            
            self.myDiaryCount = Int(snapshot.childrenCount)
            self.util.printLog(viewC: self, tag: "自分の日記の数", contents: self.myDiaryCount)
            
            var userNumber:Int = 0
            var otherUserArray:Array<Dictionary<String,String>> = allUserArray
            
            
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
            self.util.printLog(viewC: self, tag: "自分以外の全ユーザー情報", contents: otherUserArray)
            
            
            if self.myDiaryCount <= otherUserArray.count{
                
                userNumber = self.myDiaryCount
            }else{
                userNumber = otherUserArray.count
            }
            if userNumber == 0{
                SVProgressHUD.dismiss()
            }
            self.util.printLog(viewC: self, tag: "取得する日記の数", contents: userNumber)
            
            
            for i in 0 ..< userNumber{
                
                
                let randomNumber:Int = Int(arc4random_uniform(UInt32(otherUserArray.count)))
                let targetUser:Dictionary<String,String> = otherUserArray[randomNumber]
                
                self.util.printLog(viewC: self, tag: "randomNumber", contents: randomNumber)
                self.util.printLog(viewC: self, tag: "取得予定の日記のユーザー情報", contents: targetUser)
                
                self.ref.child(targetUser["user"]!).observe(DataEventType.value, with: { snapshot in
                    let randomDiaryNumber:Int = Int(arc4random_uniform(UInt32(snapshot.childrenCount)))
                    self.util.printLog(viewC: self, tag: "randomDiaryNumber", contents: randomDiaryNumber)
                    
                    let targetSnapshot = snapshot.children.allObjects[randomDiaryNumber] as! DataSnapshot
                    
                    
                    let targetDictionary = targetSnapshot.value as! [String : AnyObject]
                    self.util.printLog(viewC: self, tag: "日記の情報", contents: targetDictionary)
                    
                    for (key, value) in targetDictionary {
                        if (key == "date"){
                            self.dateArray.append(value as! String)
                            self.dateArrayFireBase.append(value as! String)
                        }else if (key == "title"){
                            self.titleArray.append(value as! String)
                             self.titleArrayFireBase.append(value as! String)
                        }else if (key == "downloadURL"){
                            let loadedImageData = NSData(contentsOf: NSURL(string:value as! String) as! URL)
                            self.picArray.append(UIImage(data: loadedImageData as! Data)!)
                             self.picArrayFireBase.append(UIImage(data: loadedImageData as! Data)!)
                        }else if (key == "main"){
                            self.mainArray.append(value as! String)
                            self.mainArrayFireBase.append(value as! String)
                        }
                    }
                    
                    
                    //self.ref.child(targetUser["user"]!).removeAllObservers()
                    
                    if i == userNumber-1 {
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                
                })
                
            }
            //lef.child(uuid).removeAllObservers()
            
        })
        
    }
    
    func changeFriendeDiary(){
        
        //配列の要素を全て削除
        dateArray.removeAll()
        titleArray.removeAll()
        mainArray.removeAll()
        picArray.removeAll()
        
        //ロード中のダイアログを表示する
        SVProgressHUD.show()
        
         self.util.printLog(viewC: self, tag: "取得条件", contents: "友達")
        //全ユーザー情報を取得
        let allUserArray:Array<Dictionary<String,String>> = userDefaults.array(forKey: "allUser") as! Array<Dictionary<String,String>>
        util.printLog(viewC: self, tag: "全ユーザー情報", contents: allUserArray)
        
        //自分の日記数を取得
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let lef = Database.database().reference()
        
        lef.child(uuid).observe(.value, with:{ (snapshot)  in
            
            self.myDiaryCount = Int(snapshot.childrenCount)
            self.util.printLog(viewC: self, tag: "自分の日記の数", contents: self.myDiaryCount)
            
            var userNumber:Int = 0
            self.userDefaults.register(defaults: ["friendsArray": Array<Dictionary<String,String>>()])
            var friendsUserArray:Array<Dictionary<String,String>> = self.userDefaults.object(forKey: "friendsArray") as! Array<Dictionary<String, String>>
            
            self.util.printLog(viewC: self, tag: "友達一覧", contents: friendsUserArray)
            
            if self.myDiaryCount <= friendsUserArray.count{
                userNumber = self.myDiaryCount
            }else{
                userNumber = friendsUserArray.count
            }
            if userNumber == 0{
                       SVProgressHUD.dismiss()
            }
            
            self.util.printLog(viewC: self, tag: "取得する日記の数", contents: userNumber)
            
            for i in 0 ..< userNumber{
                
                let randomNumber:Int = Int(arc4random_uniform(UInt32(friendsUserArray.count)))
                let targetUser:Dictionary<String,String> = friendsUserArray[randomNumber]
                self.util.printLog(viewC: self, tag: "randomNumber", contents: randomNumber)
                self.util.printLog(viewC: self, tag: "取得予定の日記のユーザー情報", contents: targetUser)
                
                self.ref.child(targetUser["friendID"]!).observe(DataEventType.value, with: { snapshot in
                    let randomDiaryNumber:Int = Int(arc4random_uniform(UInt32(snapshot.childrenCount)))
                    self.util.printLog(viewC: self, tag: "randomDiaryNumber", contents: randomDiaryNumber)
                    let targetSnapshot = snapshot.children.allObjects[randomDiaryNumber] as! DataSnapshot
                    
                    let targetDictionary = targetSnapshot.value as! [String : AnyObject]
                    self.util.printLog(viewC: self, tag: "日記の情報", contents: targetDictionary)
                    for (key, value) in targetDictionary {
                        if (key == "date"){
                            self.dateArray.append(value as! String)
                            self.dateArrayFireBase.append(value as! String)
                        }else if (key == "title"){
                            self.titleArray.append(value as! String)
                            self.titleArrayFireBase.append(value as! String)
                        }else if (key == "downloadURL"){
                            let loadedImageData = NSData(contentsOf: NSURL(string:value as! String) as! URL)
                            self.picArray.append(UIImage(data: loadedImageData as! Data)!)
                             self.picArrayFireBase.append(UIImage(data: loadedImageData as! Data)!)
                        }else if (key == "main"){
                            self.mainArray.append(value as! String)
                            self.mainArrayFireBase.append(value as! String)
                        }
                    }
                    
                   //self.ref.child(targetUser["friendID"]!).removeAllObservers()
                    
                    if i == userNumber-1 {
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    
                    
                })
                
            }
            
            //lef.child(uuid).removeAllObservers()
            
        })
        
        
        
    }
    
    
    @IBAction func segumentControllTap(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            print("first")
            dateArray.removeAll()
            titleArray.removeAll()
            mainArray.removeAll()
            picArray.removeAll()
            
            dateArray = dateArrayFireBase
            titleArray = titleArrayFireBase
            mainArray = mainArrayFireBase
            picArray = picArrayFireBase
            
            isMyDiary = false
           
        case 1:
            print("second")
            myDiary()
            isMyDiary = true
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        util.printLog(viewC: self, tag: "タッチされた場所", contents: indexPath.row)
        indexPathNumber = indexPath.row
        performSegue(withIdentifier: "toShowController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toShowController" {
            //画面遷移前に、選ばれたCellの日付の情報をShowControllerに渡しておく
            let showController:ShowController = segue.destination as! ShowController
            showController.isCellTryViewController = true
            showController.isMyDiary = isMyDiary
            showController.selectedDateString = dateArray[indexPathNumber]
            showController.cellTryViewControllerTitle = titleArray[indexPathNumber]
            showController.cellTryViewControllerMain = mainArray[indexPathNumber]
        showController.cellTryViewControllerImage = picArray[indexPathNumber]
            
        }
        
    }
}



