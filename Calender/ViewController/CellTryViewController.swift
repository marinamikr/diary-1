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
    
    
    @IBOutlet weak var changeAndMy: UISegmentedControl!
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
    var changeCheckArray:[Bool] = Array()
    
    var dateArrayFireBase: [String] = Array()
    var titleArrayFireBase: [String] = Array()
    var mainArrayFireBase: [String] = Array()
    var picArrayFireBase: [UIImage] = Array()
    
    var isMyDiary = false
    
    
    
    var userDefaults:UserDefaults = UserDefaults.standard
    var ref :DatabaseReference!
    
    static var isFirst:Bool = true
    
    var indexPathNumber:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        tableView.estimatedRowHeight = 10//セルの高さの見積もり
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(UINib(nibName:"CustumTableCell",bundle: nil),forCellReuseIdentifier: "custumTableCell")
        
        var allUserArray = Array<Dictionary<String,String>>()
        
        let lef = Database.database().reference()
        lef.child("UserIDArray").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            print("hoge")
            print(snapshot.key)
            let id = String(describing: snapshot.childSnapshot(forPath: "userID").value!)
            print(id)
            var user: Dictionary<String,String> = ["user":id]
            allUserArray.append(user)
            self?.userDefaults.set(allUserArray, forKey: "allUser")
        })
        
        lef.child("UserIDArray").observe(.childRemoved, with: { [weak self](snapshot) -> Void in
            print("hogehogehoge")
            print(snapshot.key)
            let id = String(describing: snapshot.childSnapshot(forPath: "userID").value!)
            print(id)
            for i in 0 ..< allUserArray.count{
                if allUserArray[i]["user"] == id {
                    print("hogehoge")
                    print(snapshot.key)
                    print(i)
                    allUserArray.remove(at: i)
                    print(allUserArray)
                    break
                }
            }
            
            self?.userDefaults.set(allUserArray, forKey: "allUser")
        })
        
        changeAndMy.layer.cornerRadius = 5
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayoutColor()
        print(CellTryViewController.isFirst)
        //changeDiary()
        if CellTryViewController.isFirst == true && isMyDiary == false {
            CellTryViewController.isFirst = false
            userDefaults.register(defaults: ["isAllUser": true])
            let  isAllUser = userDefaults.object(forKey: "isAllUser") as! Bool
            if isAllUser == true{
                changeAllUserDiary()
                //myDiary()
            }else{
                changeFriendeDiary()
                //myDiary()
            }
        }
        
        if isMyDiary == true {
            myDiary()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //端末内のある日記を取得する処理
    func myDiary(){
        //配列の要素を全て削除
        dateArray.removeAll()
        titleArray.removeAll()
        mainArray.removeAll()
        picArray.removeAll()
        self.tableView.reloadData()
        
        //Realmオブジェクトの取得
        let realm = try! Realm()
        //Realmに保存されている全ての情報を取得
        let results = Array(realm.objects(Diary.self))
        //Realmに保存されている要素の数だけfor文を回して配列に追加
        for i in 0 ..< results.count {
            
            dateArray.append(results[i].date)
            titleArray.append(results[i].title)
            changeCheckArray.append(results[i].changeCheck)
            
            
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
        
        dateArrayFireBase.removeAll()
        titleArrayFireBase.removeAll()
        mainArrayFireBase.removeAll()
        picArrayFireBase.removeAll()
        
        self.tableView.reloadData()
        
        //ロード中のダイアログを表示する
        SVProgressHUD.show()
        
        //全ユーザー情報を取得
        userDefaults.register(defaults: ["allUser": Array<Dictionary<String,String>>()])
        let allUserArray:Array<Dictionary<String,String>> = userDefaults.array(forKey: "allUser") as! Array<Dictionary<String,String>>
        util.printLog(viewC: self, tag: "全ユーザー情報", contents: allUserArray)
        
        //自分の日記数を取得
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let lef = Database.database().reference()
        lef.child(uuid).observe(.value, with:{ (snapshot)  in
             var targetUserArray = Array<String>()
            self.myDiaryCount = Int(snapshot.childrenCount)
            self.util.printLog(viewC: self, tag: "自分の日記の数", contents: self.myDiaryCount)
            
            var userNumber:Int = 0
            var otherUserArray:Array<Dictionary<String,String>> = allUserArray
            
            
            var position = -1
            
            for i in 0 ..< otherUserArray.count{
                print(i)
                let dic = otherUserArray[i]
                let ID = dic["user"]
                if ID == uuid{
                    position = i
                }
            }
            if position != -1{
            otherUserArray.remove(at: position)
            }
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
                 targetUserArray.append(targetUser["user"]!)
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
                    
                    
                    
                    if i == userNumber-1 {
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        for i in 0 ..< targetUserArray.count{
                            self.ref.child(targetUserArray[i]).removeAllObservers()
                            self.util.printLog(viewC: self, tag: "targetUser", contents: targetUserArray[i])
                        }
                        lef.child(uuid).removeAllObservers()
                    }
                    
                
                })
                
            }
            
            
        })
        
    }
    
    func changeFriendeDiary(){
        
        //配列の要素を全て削除
        dateArray.removeAll()
        titleArray.removeAll()
        mainArray.removeAll()
        picArray.removeAll()
        
        dateArrayFireBase.removeAll()
        titleArrayFireBase.removeAll()
        mainArrayFireBase.removeAll()
        picArrayFireBase.removeAll()
        
        self.tableView.reloadData()
        
        //ロード中のダイアログを表示する
        SVProgressHUD.show()
        
         self.util.printLog(viewC: self, tag: "取得条件", contents: "友達")
        //全ユーザー情報を取得
        userDefaults.register(defaults: ["allUser": Array<Dictionary<String,String>>()])
        let allUserArray:Array<Dictionary<String,String>> = userDefaults.array(forKey: "allUser") as! Array<Dictionary<String,String>>
        util.printLog(viewC: self, tag: "全ユーザー情報", contents: allUserArray)
        
        //自分の日記数を取得
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let lef = Database.database().reference()
        
        lef.child(uuid).observe(.value, with:{ (snapshot)  in
            
            var targetUserArray = Array<String>()
            
            self.myDiaryCount = Int(snapshot.childrenCount)
            self.util.printLog(viewC: self, tag: "自分の日記の数", contents: self.myDiaryCount)
            
            var userNumber:Int = 0
            self.userDefaults.register(defaults: ["friendsArray": Array<Dictionary<String,String>>()])
            var friendsUserArray:Array<Dictionary<String,String>> = self.userDefaults.object(forKey: "friendsArray") as! Array<Dictionary<String, String>>
            self.util.printLog(viewC: self, tag: "友達一覧", contents: friendsUserArray)
            
             var diaryFriendsUserArray = Array<Dictionary<String,String>>()
            
            
            for i in 0 ..< friendsUserArray.count{
                for j in 0 ..< allUserArray.count{
                    print(friendsUserArray[i]["friendID"])
                    print(allUserArray[j]["user"])
                    if friendsUserArray[i]["friendID"] == allUserArray[j]["user"]{
                        diaryFriendsUserArray.append(friendsUserArray[i])
                    }
                }
            }
            
            self.util.printLog(viewC: self, tag: "日記を投稿している友達一覧", contents: diaryFriendsUserArray)
            
            if self.myDiaryCount <= diaryFriendsUserArray.count{
                userNumber = self.myDiaryCount
            }else{
                userNumber = diaryFriendsUserArray.count
            }
            if userNumber == 0{
                       SVProgressHUD.dismiss()
            }
            
            self.util.printLog(viewC: self, tag: "取得する日記の数", contents: userNumber)
            
            
            
            for i in 0 ..< userNumber{
                
                let randomNumber:Int = Int(arc4random_uniform(UInt32(diaryFriendsUserArray.count)))
                let targetUser:Dictionary<String,String> = diaryFriendsUserArray[randomNumber]
                targetUserArray.append(targetUser["friendID"]!)
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
                    
                    
                    if i == userNumber-1 {
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        for i in 0 ..< targetUserArray.count{
                            self.ref.child(targetUserArray[i]).removeAllObservers()
                            self.util.printLog(viewC: self, tag: "targetUser", contents: targetUserArray[i])
                        }
                        lef.child(uuid).removeAllObservers()
                    }
                    
                    
                })
                
            }
            
           
            
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
            
            
            tableView.reloadData()
            
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
            util.printLog(viewC: self, tag: "isMyDiary", contents: isMyDiary)
            if isMyDiary == true{
            showController.changeCheck = changeCheckArray[indexPathNumber]
            }
            util.printLog(viewC: self, tag: "change", contents: showController.cellTryViewControllerTitle)
        }
        
    }
    
    //レイアウトの色を指定する
    func  setLayoutColor() {
        
        let colorManager = ColorManeger()
        var userDefaults:UserDefaults = UserDefaults.standard
        var colorNum:Int = 0
        
        //NSUserDefaultsから、ユーザーの指定している色の情報を取得
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }
        
        switch colorNum {
        case 0://  red
            changeAndMy.tintColor = UIColor(hex: "DD3F4B")
           
        case 1:// pink
           changeAndMy.tintColor = UIColor(hex: "F3B3BB")
           
        case 2:// orange
            changeAndMy.tintColor = UIColor(hex: "F6BD60")
           
        case 3://  yellow
             changeAndMy.tintColor = UIColor(hex: "F9DC5C")
            
            
        case 4:// green
             changeAndMy.tintColor = UIColor(hex: "4BA7A6")
   
        case 5:// blue
             changeAndMy.tintColor = UIColor(hex: "A8DADC")
           
            
        case 6://purple
            changeAndMy.tintColor = UIColor(hex: "C2BBF0")
           
            
        default:
            return
        }
    }
    
}



