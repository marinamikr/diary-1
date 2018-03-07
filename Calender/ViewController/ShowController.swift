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
//import FirebaseDatabase
//import FirebaseStorage


class ShowController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainLabel: UITextView!
    @IBOutlet weak var picture : UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var edit: UILabel!
    @IBOutlet weak var changeButton:UIButton!
    @IBOutlet weak var eraserButton:UIButton!
    @IBOutlet var captureView:UIView!//変更点
    
    
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
        
       
        //日付を表示
        dateLabel.text = selectedDateString
        //日付の情報をもとに、Realmに保存されている情報を取得
        showData(date: self.selectedDateString)
        
        if changeCheck == true {
            changeButton.isHidden = true
        }
        takeScreenShot()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        //NSUserDefaultsから、ユーザーの指定している色の情報を取得
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }
        //背景色の指定
        backButton.backgroundColor = colorManager.mainColor()[colorNum]
    }
    
    //スクショを撮影
    private func takeScreenShot() {
        self.capturedImage = getScreenShot()
    }
    
    private func getScreenShot() -> UIImage {
        let rect2 = CGRect(x:0,y:0,width:DeviceSize.screenWidth(),height:Int(self.view.frame.height-(self.navigationController?.navigationBar.frame.size.height)!))
        
        let rect = self.captureView.bounds//変更点
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.captureView.layer.render(in: context)//変更点
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
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
        
        
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        
        //変数picに画像を設定
        if let pic = picture.image{
            
            //変数dataにpicをNSDataにしたものを指定
            if let data = UIImagePNGRepresentation(pic) {
                
                // トップReferenceの一つ下の固有IDの枝を指定
                let riversRef = storageRef.child(uuid)
                
                // strageに画像をアップロード
                riversRef.putData(data, metadata: nil, completion: { metaData, error in
                    
                    // FireBaseの一番トップのReferenceを指定
                    let ref = Database.database().reference()
                    
                    //Firebaseに保存する情報の作成
                    let data : Dictionary = ["title":self.label.text,"date":self.dateLabel.text,"main":self.mainLabel.text,"downloadURL":metaData?.downloadURL()?.absoluteString]
                    
                    //トップReferenceの一つ下の固有IDの枝に、key value形式の情報を送る
                    ref.child(uuid).childByAutoId().setValue(data)
                    
                    //最初の一回のみ
                    let sentUserId = self.userDefaults.bool(forKey: "SENT_USERID")
                    if sentUserId == false {
                        self.self.addMyID()
                        self.userDefaults.set(true, forKey: "SENT_USERID")
                    }
                    
                   
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
        
        // databaseから画像の名前を取得
        let ref = Database.database().reference().child("UserIDArray")
        let data : Dictionary = ["userName":"hazuki","userID":UIDevice.current.identifierForVendor!.uuidString,]
        
        //トップReferenceの一つ下の固有IDの枝に、key value形式の情報を送る
        ref.childByAutoId().setValue(data)
        
        
    }
    
    @IBAction func eraser(){
        let realm = try! Realm()
    }
    
    
    @IBAction func back() {
        self.navigationController?.popToRootViewController(animated: true)
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
        }
        
    }
    
}
