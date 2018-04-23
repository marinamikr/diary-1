//
//  ShowController.swift
//  Calender
//
//  Created by Hazuki♪ on 2/6/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import SVProgressHUD
//import FirebaseDatabase
//import FirebaseStorage


class ShowController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainLabel: UITextView!
    @IBOutlet weak var picture : UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var changeButton:UIButton!
    @IBOutlet weak var eraserButton:UIButton!
    @IBOutlet var captureView:UIView!//変更点
    
    var util = Util()
    
    let lef = Database.database().reference()
    
    var isCellTryViewController:Bool = false
    var isMyDiary:Bool = false
    var cellTryViewControllerTitle:String = ""
    var cellTryViewControllerMain:String = ""
    var cellTryViewControllerImage:UIImage = UIImage()
    
    //選ばれた日付をStringに変換したもの
    var selectedDateString : String = ""
    //選ばれた日付
    var selectedDate : Date = Date()
    
    var selectedPicture:UIImage = UIImage()
    
    var selectedBool:Bool = true
    
    //スクリーンショット
    var capturedImage : UIImage!
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    let colorManager = ColorManeger()
    var colorNum:Int = 0
    var push:[Bool] = [false]
    var userDefaults:UserDefaults = UserDefaults.standard
    var changeCheck:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //userDefaults.set(picture, forKey: "PICTURE")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayoutColor()
        
        
        if isCellTryViewController == true && isMyDiary == false{
            
            dateLabel.text = selectedDateString
            mainLabel.text = cellTryViewControllerMain
            label.text = cellTryViewControllerTitle
            picture.image = cellTryViewControllerImage
            
            
            if isMyDiary == true{
                editButton.isHidden = false
                
                if changeCheck == true {
                    changeButton.isHidden = true
                }
                
            }else{
                changeButton.isHidden = true
                editButton.isHidden = true
            }
        }else{
            //日付を表示
            dateLabel.text = selectedDateString
            //日付の情報をもとに、Realmに保存されている情報を取得
            showData(date: self.selectedDateString)
            util.printLog(viewC: self, tag: "changeCheck", contents: changeCheck)
            if changeCheck == true {
                changeButton.isHidden = true
            }
        }
        
    }
    
    //日付の情報をもとに、Realmに保存されている情報を取得し表示
    func showData(date : String)  {
        //Realmオブジェクトの取得
        let realm = try! Realm()
        //Realmから、dateの情報が、selectedDateStringと一致するものを検索
        if let diary = realm.objects(Diary.self).filter("date == %@", date).last{
            //Viewに表示
            label.text = diary.title
            mainLabel.text = diary.main
            self.changeCheck = diary.changeCheck
            
            if diary.changeCheck == true{
                changeButton.isEnabled = false
            }
            if let photo = diary.photo {
                selectedPicture = UIImage(data: photo)!
                picture.image = selectedPicture
            }
            
        }else{
            changeButton.isHidden = true
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
            backButton.setTitleColor(UIColor(hex: "DD3F4B"), for: UIControlState.normal)
            changeButton.backgroundColor = UIColor(hex: "DD3F4B")
            editButton.setTitleColor(UIColor(hex: "DD3F4B"), for: UIControlState.normal)
            
        case 1:// pink
            backButton.setTitleColor(UIColor(hex: "F3B3BB"), for: UIControlState.normal)
            changeButton.backgroundColor = UIColor(hex:  "F3B3BB")
            editButton.setTitleColor(UIColor(hex: "F3B3BB"), for: UIControlState.normal)
            
        case 2:// orange
            backButton.setTitleColor(UIColor(hex: "F6BD60"), for: UIControlState.normal)
            changeButton.backgroundColor = UIColor(hex: "F6BD60")
            editButton.setTitleColor(UIColor(hex: "F6BD60"), for: UIControlState.normal)
            
        case 3://  yellow
            backButton.setTitleColor(UIColor(hex: "F9DC5C"), for: UIControlState.normal)
            changeButton.backgroundColor = UIColor(hex:  "F9DC5C")
            editButton.setTitleColor(UIColor(hex: "F9DC5C"), for: UIControlState.normal)
            
        case 4:// green
            backButton.setTitleColor(UIColor(hex: "4BA7A6"), for: UIControlState.normal)
            changeButton.backgroundColor = UIColor(hex: "4BA7A6")
            editButton.setTitleColor(UIColor(hex: "4BA7A6"), for: UIControlState.normal)
            
        case 5:// blue
            backButton.setTitleColor(UIColor(hex: "A8DADC"), for: UIControlState.normal)
            changeButton.backgroundColor = UIColor(hex: "A8DADC")
            editButton.setTitleColor(UIColor(hex: "A8DADC"), for: UIControlState.normal)
            
        case 6://purple
            backButton.setTitleColor(UIColor(hex: "C2BBF0"), for: UIControlState.normal)
            changeButton.backgroundColor = UIColor(hex: "C2BBF0")
            editButton.setTitleColor(UIColor(hex: "C2BBF0"), for: UIControlState.normal)
            
        default:
            return
        }
    }
    
    
    
    
    @IBAction func change() {
        changeAllUserDiary(count: 1)
        
        // 無効化
        self.changeButton.isEnabled = false
        print("mukou")
        
        changeButton.isHidden = true
        changeCheck = true
        // 端末の固有IDを取得
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        // let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        let storageRef = storage.reference(forURL: "gs://test-1c7b1.appspot.com")
        
        //変数picに画像を設定
        if let pic = resizeImage(src:picture.image!){
            
            print("koko")
            //変数dataにpicをNSDataにしたものを指定
            if let data = UIImagePNGRepresentation(pic) {
                
                //ロード中のダイアログを表示する
                //SVProgressHUD.show()
                
                // トップReferenceの一つ下の固有IDの枝を指定
                let riversRef = storageRef.child(uuid).child(String.getRandomStringWithLength(length: 60))
                
                // strageに画像をアップロード
                riversRef.putData(data, metadata: nil, completion: { metaData, error in
                    
                    // FireBaseの一番トップのReferenceを指定
                    let ref = Database.database().reference()
                    
                    //Firebaseに保存する情報の作成
                    let data : Dictionary = ["title":self.label.text,"date":self.dateLabel.text,"main":self.mainLabel.text,"downloadURL":metaData?.downloadURL()?.absoluteString]
                    
                    self.util.printLog(viewC: self, tag: "日記情報", contents: data)
                    self.util.printLog(viewC: self, tag: "uuid", contents: uuid)
                    //トップReferenceの一つ下の固有IDの枝に、key value形式の情報を送る
                    ref.child(uuid).childByAutoId().setValue(data)
                    self.changeButton.isHidden = true
                    
                    //最初の一回のみ
                    let sentUserId = self.userDefaults.bool(forKey: "SENT_USERID")
                    if sentUserId == false {
                        self.self.addMyID()
                        self.userDefaults.set(true, forKey: "SENT_USERID")
                    }
                    
                    //SVProgressHUD.dismiss()
                    
                })
            }
        }
        
        //        //交換対象のUserIdを取得
        //        var users: [[String:String]] = userDefaults.array(forKey: "users") as? [[String:String]] ?? []
        //        let ref = Database.database().reference().child("UserIDArray")
        //        ref.observe(DataEventType.value, with: { snapshots in
        //            var userData: [DataSnapshot] = []
        //            for snap in snapshots.children {
        //                userData.append(snap as! DataSnapshot)
        //            }
        //            let random = Int(arc4random_uniform(UInt32(userData.count)))
        //            let user = userData[random].value as! [String : String]
        //            users.append(user)
        //            //useridを保存
        //            self.userDefaults.set(users, forKey: "users")
        //            print("保存オK")
        //        })
        
        
    }
    
    func addMyID(){
        
        
        let ref = Database.database().reference()
        let data : Dictionary = ["userName":"hazuki","userID":UIDevice.current.identifierForVendor!.uuidString,]
        
        //トップReferenceの一つ下の固有IDの枝に、key value形式の情報を送る
        ref.child("UserIDArray").childByAutoId().setValue(data)
        
    }
    
    @IBAction func eraser(){
        let realm = try! Realm()
    }
    
    
    @IBAction func back() {
        if isCellTryViewController == true{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func editbtn() {
        //画面遷移
        performSegue(withIdentifier: "toEditViewController", sender: self)
    }
    @IBAction func pic() {
        var selectedPicture = cellTryViewControllerImage
        //画面遷移
        performSegue(withIdentifier: "picture", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditViewController" {
            //画面遷移前に、選ばれたCellの日付の情報をEditControllerに渡しておく
            let editController:EditController = segue.destination as! EditController
            editController.selectedDate = self.selectedDate
            editController.selectedDateString = self.selectedDateString
            editController.isCellTryViewController = self.isCellTryViewController
            editController.selectedBool = self.changeCheck
        }else
            if segue.identifier == "picture" {
                //画面遷移前に、渡しておく
                let pictureViewController:PictureViewController = segue.destination as! PictureViewController
                pictureViewController.selectedPicture = self.selectedPicture
                
        }
        
    }
    
    /// イメージのサイズを変更
    func resizeImage(src: UIImage!) -> UIImage! {
        
        var resizedSize : CGSize!
        let maxLongSide : CGFloat = 500
        
        // リサイズが必要か？
        let ss = src.size
        if maxLongSide == 0 || ( ss.width <= maxLongSide && ss.height <= maxLongSide ) {
            resizedSize = ss
            return src
        }
        
        // TODO: リサイズ回りの処理を切りだし
        
        // リサイズ後のサイズを計算
        let ax = ss.width / maxLongSide
        let ay = ss.height / maxLongSide
        let ar = ax > ay ? ax : ay
        let re = CGRect(x: 0, y: 0, width: ss.width / ar, height: ss.height / ar)
        
        // リサイズ
        UIGraphicsBeginImageContext(re.size)
        src.draw(in: re)
        let dst = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        resizedSize = dst?.size
        
        return dst!
    }
    
    //サーバー上の日記を取得する処理
    func changeAllUserDiary(count:Int){
        if count >= 100{
            return
        }
        self.util.printLog(viewC: self, tag: "取得条件", contents: "全ユーザー")
        
        //全ユーザー情報を取得
        userDefaults.register(defaults: ["allUser": Array<Dictionary<String,String>>()])
        let allUserArray:Array<Dictionary<String,String>> = userDefaults.array(forKey: "allUser") as! Array<Dictionary<String,String>>
        util.printLog(viewC: self, tag: "全ユーザー情報", contents: allUserArray)
        
        //自分の日記数を取得
        let uuid = UIDevice.current.identifierForVendor!.uuidString
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
        
        if otherUserArray.count == 0{
            return
        }
        
        let randomNumber:Int = Int(arc4random_uniform(UInt32(otherUserArray.count)))
        let targetUser:Dictionary<String,String> = otherUserArray[randomNumber]
        
        
        self.util.printLog(viewC: self, tag: "randomNumber", contents: randomNumber)
        self.util.printLog(viewC: self, tag: "取得予定の日記のユーザー情報", contents: targetUser)
        
        self.lef.child(targetUser["user"]!).observeSingleEvent(of: DataEventType.value, with: { snapshot in
        //一回だけfirebaseを読み込む
            let randomDiaryNumber:Int = Int(arc4random_uniform(UInt32(snapshot.childrenCount)))
            self.util.printLog(viewC: self, tag: "randomDiaryNumber", contents: randomDiaryNumber)
            
            let targetSnapshot = snapshot.children.allObjects[randomDiaryNumber] as! DataSnapshot
            
            self.util.printLog(viewC: self, tag: "Key", contents: targetSnapshot.key)
            
            let targetDictionary = targetSnapshot.value as! [String : AnyObject]
            self.util.printLog(viewC: self, tag: "日記の情報", contents: targetDictionary)
            
            var date :String!
            var main :String!
            var title :String!
            var photo: Data!
            
            let diary = ChangeDiary()
            
            for (key, value) in targetDictionary {
                if (key == "date"){
                    date = value as! String
                    self.util.printLog(viewC: self, tag: "日付情報", contents: value as! String)
                }else if (key == "title"){
                    title = value as! String
                    self.util.printLog(viewC: self, tag: "タイトル情報", contents: value as! String)
                }else if (key == "downloadURL"){
                    photo = NSData(contentsOf: NSURL(string:value as! String)! as URL)! as Data
                }else if (key == "main"){
                    main = value as! String
                    self.util.printLog(viewC: self, tag: "メイン情報", contents: value as! String)
                }
            }
            
            
            //Realmに保存
            // STEP.1 Realmを初期化
            let realm = try! Realm()
            
            //STEP.2 保存する要素を書く
            diary.date = date
            diary.title = title
            diary.photo = photo
            diary.main = main
            diary.ID = targetSnapshot.key
            
            // Realmに保存されてるDog型のオブジェクトを全て取得
            if let diary = realm.objects(ChangeDiary.self).filter("ID == %@", diary.ID).last {
                defer { self.changeAllUserDiary(count: count + 1) }
                //defer:メソッドを抜けた後に呼ばれる
                return
            }
            
            
            //STEP.3 Realmに書き込み
            try! realm.write {
                realm.add(diary, update: true)
            }
            self.self.util.printLog(viewC: self, tag: "保存した情報", contents: diary)
        })
        
    }
}
