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
    
    var isCellTryViewController:Bool = false
    var isMyDiary:Bool = false
    var cellTryViewControllerTitle:String = ""
    var cellTryViewControllerMain:String = ""
    var cellTryViewControllerImage:UIImage = UIImage()
    
    //選ばれた日付をStringに変換したもの
    var selectedDateString : String = ""
    //選ばれた日付
    var selectedDate : Date = Date()
    
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
        
        if isCellTryViewController == true{
           
            dateLabel.text = selectedDateString
            mainLabel.text = cellTryViewControllerMain
            label.text = cellTryViewControllerTitle
            picture.image = cellTryViewControllerImage
            if changeCheck == true {
                changeButton.isHidden = true
            }
            
            if isMyDiary == true{
                editButton.isHidden = false
            }else{
                editButton.isHidden = true
            }
        }else{
            //日付を表示
            dateLabel.text = selectedDateString
            //日付の情報をもとに、Realmに保存されている情報を取得
            showData(date: self.selectedDateString)
            
            if changeCheck == true {
                changeButton.isHidden = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayoutColor()
        //日付の情報をもとに、Realmに保存されている情報を取得
        showData(date: self.selectedDateString)
        
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
                picture.image = UIImage(data: photo)
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
            changeButton.setTitleColor(UIColor(hex: "DD3F4B"), for: UIControlState.normal)
            editButton.setTitleColor(UIColor(hex: "DD3F4B"), for: UIControlState.normal)
            
        case 1:// pink
           backButton.setTitleColor(UIColor(hex: "F3B3BB"), for: UIControlState.normal)
            changeButton.setTitleColor(UIColor(hex: "F3B3BB"), for: UIControlState.normal)
            editButton.setTitleColor(UIColor(hex: "F3B3BB"), for: UIControlState.normal)
            
        case 2:// orange
            backButton.setTitleColor(UIColor(hex: "F6BD60"), for: UIControlState.normal)
            changeButton.setTitleColor(UIColor(hex: "F6BD60"), for: UIControlState.normal)
            editButton.setTitleColor(UIColor(hex: "F6BD60"), for: UIControlState.normal)
            
        case 3://  yellow
            backButton.setTitleColor(UIColor(hex: "F9DC5C"), for: UIControlState.normal)
            changeButton.setTitleColor(UIColor(hex: "F9DC5C"), for: UIControlState.normal)
            editButton.setTitleColor(UIColor(hex: "F9DC5C"), for: UIControlState.normal)
            
        case 4:// green
            backButton.setTitleColor(UIColor(hex: "4BA7A6"), for: UIControlState.normal)
            changeButton.setTitleColor(UIColor(hex: "4BA7A6"), for: UIControlState.normal)
            editButton.setTitleColor(UIColor(hex: "4BA7A6"), for: UIControlState.normal)
            
        case 5:// blue
            backButton.setTitleColor(UIColor(hex: "A8DADC"), for: UIControlState.normal)
            changeButton.setTitleColor(UIColor(hex: "A8DADC"), for: UIControlState.normal)
            editButton.setTitleColor(UIColor(hex: "A8DADC"), for: UIControlState.normal)
            
        case 6://purple
            backButton.setTitleColor(UIColor(hex: "C2BBF0"), for: UIControlState.normal)
            changeButton.setTitleColor(UIColor(hex: "C2BBF0"), for: UIControlState.normal)
            editButton.setTitleColor(UIColor(hex: "C2BBF0"), for: UIControlState.normal)
            
        default:
            return
        }
    }
    
    
    
    
    @IBAction func change() {
        // 無効化
        self.changeButton.isEnabled = false
        print("mukou")
        //Realmオブジェクトの取得
        let realm = try! Realm()
        
        if let diary = realm.objects(Diary.self).filter("date == %@", self.selectedDateString).last{
            try! realm.write {
                diary.changeCheck = true
            }
        }
        
        // 端末の固有IDを取得
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        
        //変数picに画像を設定
        if let pic = picture.image{
            
            print("koko")
            //変数dataにpicをNSDataにしたものを指定
            if let data = UIImagePNGRepresentation(pic) {
                
                //ロード中のダイアログを表示する
                //SVProgressHUD.show()
                
                // トップReferenceの一つ下の固有IDの枝を指定
                let riversRef = storageRef.child(uuid)
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toEditViewController" {
            //画面遷移前に、選ばれたCellの日付の情報をShowControllerに渡しておく
            let editController:EditController = segue.destination as! EditController
            editController.selectedDate = self.selectedDate
            editController.selectedDateString = self.selectedDateString
            editController.isCellTryViewController = self.isCellTryViewController
        }
        
    }
    
}
