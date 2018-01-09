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
    
    @IBOutlet var addpictureButton:UIButton!
    
    var colorNum:Int = 0
    let colorManager = ColorManeger()
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    var scale:CGFloat = 1.0
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBOutlet weak var textView: PlaceHolderTextView!
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
        
        
    }
    
    @IBOutlet var haikei: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }
        haikei.backgroundColor = colorManager.mainColor()[colorNum]
        textField.delegate = self
        //textView.delegate = self
        textView.placeHolder = "ここに書く"
        
        
        //
        //        addpictureButton.titleLabel?.numberOfLines = 2
        //        addpictureButton.titleLabel?.text = "add\npicture"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //非表示にする。
        if(textView.isFirstResponder){
            textView.resignFirstResponder()
        }else if(textField.isFirstResponder){
            textField.resignFirstResponder()
        }
        
    }
    
    
    
    
    @IBAction func picture() {
        addpictureButton.isHidden = true
        //        //UIImagePicker Controllerのインスタンスを作る
        //        let imagePickerController: UIImagePickerController = UIImagePickerController()
        //
        //        //フォトライブラリを使う設定をする
        //        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //        imagePickerController.delegate = self
        //        imagePickerController.allowsEditing = true
        //
        //
        //      //  imagePickerController= [NSForegroundColorAttributeName : UIColor.greenColor()]
        //
        //        //フォトライブラリを呼び出す
        //        self.present(imagePickerController, animated: true, completion: nil)
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        // カメラが利用可能かチェック
        //if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
        // インスタンスの作成
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true, completion: nil)
        
        //}
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    //フォトライブラリから画像の選択が終わったら呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //imageに選んだ画像を表示する
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        //そのimageを背景に設定する
        haikei.image = image
        
        //フォトライブラリを閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func oooo() {
    }
    
    @IBAction func add() {
        
        //アラート
        let alert:UIAlertController = UIAlertController(title: "OK", message: "saved diary",preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "got it",
                                      style: UIAlertActionStyle.default,
                                      handler: {action in
                                        
                                        print("hoge")
                                        //ボタンが押されたら
                                        
                                        // STEP.1 Realmを初期化
                                        let realm = try! Realm()
                                        
                                        //STEP.2 保存する要素を書く
                                        let diary = Diary()
                                        let calendar = Calendar.current
                                        //                let component = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: self.datepicker.date)
                                        //
                                        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self.datepicker.date)
                                        
                                        if component.day! <= 9{
                                            diary.date = String(component.year!)+"/"+String(component.month!)+"/0" + String(component.day!)
                                            

                                        }else{
                                            diary.date = String(component.year!)+"/"+String(component.month!)+"/" + String(component.day!)
                                            

                                        }
                                        
                                        print(diary.date)
                                       
                                        diary.iddate = String(describing: Date())
                                        
                                        diary.main = self.textView.text
                                        diary.title = self.textField.text!
                                        print("ok1")
                                        if let photo = self.haikei.image
                                        {
                                            diary.photo = NSData(data: UIImageJPEGRepresentation(photo,1)!) as Data
                                        }
                                        print("ok2")
                                        
                                        //STEP.3 Realmに書き込み
                                        try! realm.write {
                                            realm.add(diary, update: true)
                                        }
                                        
                                        
                                        self.navigationController?.popViewController(animated: true)
                                        self.dismiss(animated: true, completion: nil)
                                        
        }
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func delete () {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var date: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // dateLabel.text = date
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
            
        }
        haikei.backgroundColor = colorManager.mainColor()[colorNum]
        self.configureObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) //エフェクト関係のパラメタだと思うが、今回は使用しないので、基底クラスを呼び出して、終わり。
        var _: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateオブジェクトの呼び出し。as ◯◯はSwiftのキャスト表現
        //appDelegate.ViewVal = textField.text! // TextFieldの値を取得し、値引き渡し用のプロパティにセット
        
        self.removeObserver()
    }
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    func keyboardWillShow(notification: Notification?) {
        
        if(textView.isFirstResponder){
            let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!, animations: { () in
                let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
                self.view.transform = transform
                
            })
        }
        
    }
    
    // キーボードが消えたときに、画面を戻す
    func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}
