//
//  ConnectViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 2018/04/13.
//  Copyright © 2018年 hazuki. All rights reserved.
//

import UIKit
import SafariServices


class ConnectViewController: UIViewController {
    
    @IBAction func twitterText() {
        let twitterUrl = NSURL(string: "https://twitter.com/Sendiary_")
        
        if let twitterUrl = twitterUrl {
            
            let safariViewController = SFSafariViewController(url: twitterUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        let twitterUrl = NSURL(string: "https://twitter.com/Sendiary_")
        
        if let twitterUrl = twitterUrl {
            
            let safariViewController = SFSafariViewController(url: twitterUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func boxText() {
        let boxUrl = NSURL(string: "https://peing.net/ja/sendiary_")
        
        if let boxUrl = boxUrl {
            
            let safariViewController = SFSafariViewController(url: boxUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
        
    }
    @IBAction func boxButton(sender: AnyObject) {
        let boxUrl = NSURL(string: "https://peing.net/ja/sendiary_")
        
        if let boxUrl = boxUrl {
            
            let safariViewController = SFSafariViewController(url: boxUrl as URL)
            present(safariViewController, animated: false, completion: nil)
        }
    }
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutColor()
        
        //トップに戻るボタンを作成
        let leftButton = UIBarButtonItem(title: "⬅︎", style: UIBarButtonItemStyle.plain, target: self, action: "goTop")
        self.navigationItem.leftBarButtonItem = leftButton
    }
    //トップに戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //トップ画面に戻る。
        self.navigationController?.popToRootViewController(animated: true)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

