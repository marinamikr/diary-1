//
//  QRController.swift
//  Calender
//
//  Created by 橋詰明宗 on 2018/01/30.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit

class QRController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         qr.image = makeQRCodeImage(text: UIDevice.current.identifierForVendor!.uuidString)

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
