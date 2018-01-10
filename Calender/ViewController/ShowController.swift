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
        
        //Realmオブジェクトの取得
        let realm = try! Realm()
        //Realmから、dateの情報が、selectedDateStringと一致するものを検索
        if let diary = realm.objects(Diary.self).filter("date == %@", self.selectedDateString).last{
            
            
            label.text = diary.title
            mainLabel.text = diary.main
            changeCheck = diary.changeCheck
            
            
            if let photo = diary.photo {
                picture.image = UIImage(data: photo)
                let data = UIImage(data: photo)
                userDefaults.set(photo, forKey: "picture")
            }
            
            userDefaults.set(diary.title, forKey: "title")
            userDefaults.set(selectedDateString, forKey: "date")
            userDefaults.set(diary.title, forKey: "main")
            
        }
        
        if changeCheck == true {
            changeButton.isHidden = true
        }
        takeScreenShot()
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
        
        // 端末の固有IDを取得
        let uuid = NSUUID().uuidString
        
        // strageの一番トップのReferenceを指定
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        
        if let pic = picture.image{
            
            if let data = UIImagePNGRepresentation(pic) {
                
                // トップReferenceの一つ下の固有IDの枝を指定
                let riversRef = storageRef.child(uuid)
                
                // strageに画像アップロード
                riversRef.putData(data, metadata: nil, completion: { metaData, error in
                    
                    // FireBaseの一番トップのReferenceを指定
                    let ref = Database.database().reference()
                    
                    //Firebaseに保存する情報の作成
                    let data : Dictionary = ["title":self.label.text,"date":self.dateLabel.text,"main":self.mainLabel.text,"downloadURL":metaData?.downloadURL()?.absoluteString]
                    
                    //トップReferenceの一つ下の固有IDの枝に、key value形式の情報を送る
                    ref.child(uuid).setValue(data)
                    
                    
                })
            }
        }
        
        if let number = userDefaults.object(forKey: "SAVE") as? Int {
            userDefaults.set(number + 1, forKey: "SAVE")
        } else {
            userDefaults.set(1, forKey: "SAVE")
        }
        
    }
    
    @IBAction func eraser(){
        let realm = try! Realm()
    }
    
    
    @IBAction func back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func editbtn() {
        
    }
    
}
