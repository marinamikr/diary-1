//
//  ViewController.swift
//  AVCaptureMetadataOutputSample_QRCodeReader
//
//  Created by hirauchi.shinichi on 2016/12/19.
//  Copyright © 2016年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import AVFoundation

class FriendsController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var textField: UITextView!
    var userDefaults:UserDefaults = UserDefaults.standard
    
    
    // セッションのインスタンス生成
    let captureSession = AVCaptureSession()
    var videoLayer: AVCaptureVideoPreviewLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
                    textField.text = metadata.stringValue!
                    let id = metadata.stringValue
                    
                    userDefaults.register(defaults: ["userIDs": []])
                    var userIDs = userDefaults.object(forKey: "userIDs") as! Array<String>
                    
                    if !(userIDs.contains(id!)){
                        userIDs.append(id!)
                        userDefaults.set(userIDs,forKey:"userIDs")
                        userDefaults.synchronize()
                    }
                    
                    print(userIDs)
                    
                    
                    
                    
                    self.captureSession.stopRunning()
                    
                    let alert = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
                    
                    // OKボタンの設定
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                        (action:UIAlertAction!) -> Void in
                        
                        // OKを押した時入力されていたテキストを表示
                        if let textFields = alert.textFields {
                            
                            // アラートに含まれるすべてのテキストフィールドを調べる
                            for textField in textFields {
                                print(textField.text!)
                                
                            }
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





