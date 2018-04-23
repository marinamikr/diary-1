//
//  ViewController.swift
//  AVCaptureMetadataOutputSample_QRCodeReader
//
//  Created by hirauchi.shinichi on 2016/12/19.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class FriendsController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var textField: UITextView!
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    // セッションのインスタンス生成
    let captureSession = AVCaptureSession()
    var videoLayer: AVCaptureVideoPreviewLayer?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutColor()
        // 入力（背面カメラ）
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice)
        captureSession.addInput(videoInput)
        
        // 出力（メタデータ）
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        
        // QRコードを検出した際のデリゲート設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // QRコードの認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // プレビュー表示
        videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer?.frame = previewView.bounds
        videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(videoLayer!)
        
        // セッションの開始
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        //トップに戻るボタンを作成
        let leftButton = UIBarButtonItem(title: "⬅︎", style: UIBarButtonItemStyle.plain, target: self, action: "goTop")
        self.navigationItem.leftBarButtonItem = leftButton
    }
    //トップに戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //トップ画面に戻る。
        self.navigationController?.popToRootViewController(animated: true)
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 複数のメタデータを検出できる
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRコードのデータかどうかの確認
            if metadata.type == AVMetadataObjectTypeQRCode {
                // 検出位置を取得
                let barCode = videoLayer?.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
                
                if metadata.stringValue != nil {
                    // 検出データを取得
                    let id = metadata.stringValue
                    let defaultArray = Array<Dictionary<String,String>>()
                    userDefaults.register(defaults: ["friendsArray": defaultArray])
                    
                    var friendsArray:Array<Dictionary<String,String>> = userDefaults.object(forKey: "friendsArray") as! Array<Dictionary<String,String>>
                    var isContain:Bool = false
                    for i in 0..<friendsArray.count{
                        let friend:Dictionary<String,String> = friendsArray[i]
                        let friendID:String = friend["friendID"]!
                        
                        if friendID == id {
                            isContain = true
                        }
                    }
                    
                    if isContain == false {
                        
                        self.captureSession.stopRunning()
                        
                        let alert = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
                        
                        // OKボタンの設定
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                            (action:UIAlertAction!) -> Void in
                            
                            // OKを押した時入力されていたテキストを表示
                            if let textFields = alert.textFields {
                                
                                let newFriend:Dictionary<String,String> = ["friendID":id!,"friendName":textFields[0].text!]
                                print(newFriend)
                                print(friendsArray)
                                friendsArray.append(newFriend)
                                print(friendsArray)
                                self.userDefaults.set(friendsArray, forKey: "friendsArray")
                            }
                        })
                        
                        alert.addAction(okAction)
                        
                        // キャンセルボタンの設定
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        
                        // テキストフィールドを追加
                        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                            textField.placeholder = "テキスト"
                        })
                        
                        // 複数追加したいならその数だけ書く
                        // alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                        //     textField.placeholder = "テキスト"
                        // })
                        
                        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
                        
                        // アラートを画面に表示
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
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
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "DD3F4B")
            
        case 1:// pink
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "F3B3BB")
            
        case 2:// orange
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "F6BD60")
            
        case 3://  yellow
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "F9DC5C")
            
            
        case 4:// green
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "4BA7A6")
            
        case 5:// blue
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "A8DADC")
            
            
        case 6://purple
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "C2BBF0")
            
        default:
            return
        }
    }
}





