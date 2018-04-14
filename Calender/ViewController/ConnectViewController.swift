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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
