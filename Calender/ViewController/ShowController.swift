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
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    let colorManager = ColorManeger()
    var colorNum:Int = 0
    var push:[Bool] = [false]
    var userDefaults:UserDefaults = UserDefaults.standard
    var changeCheck:Bool = false
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainLabel: UITextView!
    @IBOutlet weak var picture : UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var edit: UILabel!
    @IBOutlet weak var changeButton:UIButton!
    @IBOutlet weak var eraserButton:UIButton!
    
    
    @IBOutlet var captureView:UIView!//変更点
    
    var capturedImage : UIImage!
    
    var year:String = ""
    var month:String = ""
    var date:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }
        
        backButton.backgroundColor = colorManager.mainColor()[colorNum]
        
        
        
        let year = appDelegate.year //appDelegateの変数を操作
        let month = appDelegate.month
        let date = appDelegate.date
        dateLabel.text = "\(year!),　\(month!),　\(date!)"//2017,4,3
        
        
        let realm = try! Realm()
        //realmから\(year!)\(month!)\(date!)で検索
        if let diary = realm.objects(Diary.self).filter("date == \(year!)\(month!)\(date!)").last {
            label.text = diary.title
            dateLabel.text = String("\(year!),　\(month!),　\(date!)")
            mainLabel.text = diary.main
            changeCheck = diary.changeCheck
            
            
            print(changeCheck)
            
            if let photo = diary.photo {
                picture.image = UIImage(data: photo)
                let data = UIImage(data: photo)
                userDefaults.set(photo, forKey: "picture")
            }
            
            userDefaults.set(diary.title, forKey: "title")
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy, MM, dd"
            userDefaults.set(String("\(year!), \(month!), \(date!)"), forKey: "date")
            userDefaults.set(diary.title, forKey: "main")
            
            
        }
        
        if changeCheck == true {
            changeButton.isHidden = true
        }
        
        
        setup()
    }
    
    //スクショとか
    private func setup() {
        capturedImage = getScreenShot() as UIImage
        
    }
    
    private func getScreenShot() -> UIImage {
        let rect2 = CGRect(x:0,y:0,width:DeviceSize.screenWidth(),height:Int(self.view.frame.height-(self.navigationController?.navigationBar.frame.size.height)!))
        
        let rect = self.captureView.bounds//変更点
        //        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        //
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.captureView.layer.render(in: context)//変更点
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //label.text =  appDelegate.ViewVal // Labelに値引き渡し用のプロパティから取得して設定する。
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }
    }
    
    @IBAction func change() {
        // 画像の名前(uuid)
        
        let uuid = NSUUID().uuidString
        
        // databaseに名前を送信
        let ref = Database.database().reference()
        ref.child("photo").childByAutoId().setValue(uuid)
        
        
        // strageに画像アップロード
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://calender-4a2d3.appspot.com")
        if let data = UIImagePNGRepresentation(capturedImage!) {
            let riversRef = storageRef.child(uuid)
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                print(metaData)
                print(error)
                
                
                
            })
        }
        
        if let number = userDefaults.object(forKey: "SAVE") as? Int {
            userDefaults.set(number + 1, forKey: "SAVE")
        } else {
            userDefaults.set(1, forKey: "SAVE")
        }
        
        
        let year = appDelegate.year //appDelegateの変数を操作
        let month = appDelegate.month
        let date = appDelegate.date
        
        let realm = try! Realm()
        
        
        
        print(realm)
        //
        //        if let diary = realm.objects(Diary.self).filter("date == \(year!)\(month!)\(date!)").last {
        //
        //
        //            diary.changeCheck = true
        //
        //
        //
        //
        //            try! realm.write {
        //                realm.add(diary, update: true)
        //            }
        //
        //        }
        //
        //
        
        
        //       if
        //        userDefaults.set( push, forKey: "PUSH")
        
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
