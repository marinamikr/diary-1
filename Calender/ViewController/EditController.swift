//  EditController.swift
//  Calender
//
//  Created by Hazuki♪ on 2/4/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class EditController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: PlaceHolderTextView!
    @IBOutlet var haikei: UIImageView!
    @IBOutlet var addpictureButton:UIButton!
    @IBOutlet var deleteButton:UIButton!
    
    //選ばれた日付をStringに変換したもの。ViewControllerから直接画面遷移した場合はnil
    var selectedDateString : String!
    //選ばれた日付。ViewControllerから直接画面遷移した場合はnil
    var selectedDate : Date!
    
    var isCellTryViewController:Bool = false
    var util = Util()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //  datepicker.setValue(UIColor.white, forKey: "textColor")
        
         textField.backgroundColor = UIColor.white
             textView.backgroundColor = UIColor.white
        setLayoutColor() //レイアウトの色を指定
        textField.delegate = self
        
        textView.placeHolder = "ここに書く"
        util.printLog(viewC: self, tag: "hoge", contents: selectedDateString)
        
        if let pickerView = self.datepicker.subviews.first {
            
            for subview in pickerView.subviews {
                
                if subview.frame.height <= 5 {
                    
                    subview.backgroundColor = UIColor.white
                    subview.tintColor = UIColor.white
                    subview.layer.borderColor = UIColor.white.cgColor
                    subview.layer.borderWidth = 0.5
                }
            }
            self.datepicker.setValue(UIColor.gray, forKey: "textColor")
        }
        
        //
        if self.selectedDateString != nil{
            //Realmに保存されている情報を取得し表示
            showData(date: self.selectedDateString)
            //Buttonのラベルを消す
            addpictureButton.setTitle("", for: .normal)
            
            
            //datepickerに日付を表示
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            selectedDate = formatter.date(from :selectedDateString)!
            datepicker.date = self.selectedDate
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = false
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayoutColor() //レイアウトの色を指定
        //self.configureObserver()// Notificationを設定
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeObserver()// Notificationを削除
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
        //背景色の指定
      //  haikei.backgroundColor = colorManager.mainColor()[colorNum]
      
    }
    
    
    //日付の情報をもとに、Realmに保存されている情報を取得し表示
    func showData(date : String)  {
        //Realmオブジェクトの取得
        let realm = try! Realm()
        //Realmから、dateの情報が、selectedDateStringと一致するものを検索
        if let diary = realm.objects(Diary.self).filter("date == %@", date).last{
            //Viewに表示
            textField.text = diary.title
            textView.text = diary.main
            if let photo = diary.photo {
                haikei.image = UIImage(data: photo)
            }
        }
    }
    
//    // Notificationを設定
//    func configureObserver() {
//        let notification = NotificationCenter.default
//        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
    
    // Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    
    @IBAction func picture() {
        
        selectImage()
    }
    
    //写真選択用のアラートを表示
    func selectImage() {
        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //カメラから画像を取得する処理
    func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラ許可をしていない時の処理")
        }
    }
    
    //フォトライブラリから画像を取得する
    func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    //フォトライブラリから画像の選択が終わったら呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //imageに選んだ画像を表示する
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //そのimageを背景に設定する
        haikei.image = image
        //Buttonのラベルを消す
        addpictureButton.setTitle("", for: .normal)
        //フォトライブラリを閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    //フォトライブラリでの画像の選択がキャンセルされた場合
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func add() {
        //アラートの作成
        let alert:UIAlertController = UIAlertController(title: "OK", message: "saved diary",preferredStyle: .alert)
        //OKボタンが押された時の処理
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.default,
                                      handler: {action in
                                        self.saveData() //Realmに保存
                                        self.navigationController?.popViewController(animated: true)//ViewControllerに戻る
                                        
        }))
        //アラートの表示
        present(alert, animated: true, completion: nil)
    }
    
    //Realmに保存
    func saveData(){
        
        // STEP.1 Realmを初期化
        let realm = try! Realm()
        
        //STEP.2 保存する要素を書く
        let diary = Diary()
        
        diary.date = self.datepicker.date.toString()
        diary.main = self.textView.text
        diary.title = self.textField.text!
        
        if self.haikei.image != nil{
            diary.photo = NSData(data: UIImageJPEGRepresentation(self.haikei.image!,1)!) as Data
        }else{
            diary.photo = NSData(data: UIImageJPEGRepresentation(UIImage(named:"にる.png")! ,1)!) as Data
        }
        
        //STEP.3 Realmに書き込み
        try! realm.write {
            realm.add(diary, update: true)
        }
        print(diary)
    }
//    @IBAction func ddeleteButton(){
//        //Realmオブジェクトの取得
//        let realm = try! Realm()
//        //Realmから、dateの情報が、selectedDateStringと一致するものを検索
//        if let diary = realm.objects(Diary.self).filter("date == %@",selectedDateString ).last{
//            try! realm.write {
//                realm.delete(diary)
//            }
//        }
//        navigationController?.popToRootViewController(animated: true)
//    }
    
    @IBAction func delete () {
        
        if isCellTryViewController == true{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }

    }
    
    
//    // キーボードが現れた時に、画面全体をずらす。
//    func keyboardWillShow(notification: Notification?) {
//
//        if(textView.isFirstResponder){
//            let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
//            let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
//            UIView.animate(withDuration: duration!, animations: { () in
//                let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
//                self.view.transform = transform
//
       //     })
       // }}
    @IBAction func onlyDelete(){
        // STEP.1 Realmを初期化
        let realm = try! Realm()
        
        if let diary = realm.objects(Diary.self).filter("date == %@", selectedDateString).last{
            
            try! realm.write() {
                realm.delete(diary)
            }
        }
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
    // キーボードが消えたときに、画面を戻す
    func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //非表示にする。
        if(textView.isFirstResponder){
            textView.resignFirstResponder()
        }else if(textField.isFirstResponder){
            textField.resignFirstResponder()
        }
        
    }
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
