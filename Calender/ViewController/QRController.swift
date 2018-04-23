//
//  QRController.swift
//  Calender
//
//  Created by 橋詰明宗 on 2018/01/30.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit

class QRController: UIViewController {

    var userDefaults:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutColor()
        
        qr.image = makeQRCodeImage(text: UIDevice.current.identifierForVendor!.uuidString)
        
        // Do any additional setup after loading the view.
        //トップに戻るボタンを作成
        let leftButton = UIBarButtonItem(title: "⬅︎", style: UIBarButtonItemStyle.plain, target: self, action: "goTop")
        self.navigationItem.leftBarButtonItem = leftButton
    }
    //トップに戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //トップ画面に戻る。
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet var qr: UIImageView!
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeQRCodeImage(text:String) -> UIImage? {
        guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        ciFilter.setDefaults()
        
        // QRコードを設定
        ciFilter.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        
        // 誤り訂正レベルを設定
        // "L" "M" "H" が設定できるみたい
        ciFilter.setValue("M", forKey: "inputCorrectionLevel")
        
        if let outputImage = ciFilter.outputImage {
            // 作成されたQRコードのイメージが小さいので拡大する
            let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
            let zoomedCiImage = outputImage.applying(sizeTransform)
            return UIImage(ciImage: zoomedCiImage, scale: 1.0, orientation: .up)
        }
        
        return nil
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


