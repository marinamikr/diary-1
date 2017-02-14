//
//  EditController.swift
//  Calender
//
//  Created by Hazuki♪ on 2/4/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit

class EditController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var textView: UITextView!
    
    func textViewShouldReturn(textField: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @IBOutlet var haikei: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textField.delegate = self
        textView.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated) //エフェクト関係のパラメタだと思うが、今回は使用しないので、基底クラスを呼び出して、終わり。
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateオブジェクトの呼び出し。as ◯◯はSwiftのキャスト表現
        appDelegate.ViewVal = textField.text! // TextFieldの値を取得し、値引き渡し用のプロパティにセット
    }
    
    
    @IBAction func picture() {
        //UIImagePicker Controllerのインスタンスを作る
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        //フォトライブラリを使う設定をする
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        //フォトライブラリを呼び出す
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //フォトライブラリから画像の選択が終わったら呼ばれるメソッド
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //imageに選んだ画像を表示する
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //そのimageを背景に設定する
        haikei.image = image
        
        //フォトライブラリを閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func add() {
        
        //アラート
        let alert:UIAlertController = UIAlertController(title: "OK", message: "saved diary",preferredStyle: .Alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "got it",
            style: UIAlertActionStyle.Default,
            handler: {action in
                //ボタンが押されたら
                self.navigationController?.popViewControllerAnimated(true)
            }
            )
        )
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //    @IBAction func getRandmNumber() {
    //
    //    }
    //
    //    //画面遷移する前に呼ばれる処理。ここで2つ目の画面（ResultViewController）に値を渡す。
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
    //
    //        //Segueのdestination（目的地）、つまりこの画面の次の画面を取得する。
    //        let resultViewController = segue.destinationViewController as! showController
    //
    //        //画面結果のnumber変数にガチャ画面で発生した乱数を渡す
    //        showController.weak = self.weak
    //
    //
    //    }
}
