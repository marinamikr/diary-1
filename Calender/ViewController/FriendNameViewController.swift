//
//  SettingViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 2017/06/20.
//  Copyright © 2017年 hazuki. All rights reserved.
//

import UIKit
import RealmSwift

class FriendNameViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UINavigationControllerDelegate{
    
    let util = Util()
    
    let userDefaults:UserDefaults = UserDefaults.standard
    var friendsSectionArray = ["友達一覧"]
    var friendsNameArray = Array<String>()
    
    var colorNumber: Int = 0
    
    let colorManager = ColorManeger()
    
    @IBOutlet var table:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutColor()
        table?.delegate = self
        table?.dataSource = self
        
        print("hoge")
        userDefaults.register(defaults: ["friendsArray": Array<Dictionary<String,String>>()])
        var friendsArray:Array<Dictionary<String,String>> = userDefaults.object(forKey: "friendsArray") as! Array<Dictionary<String,String>>
        
        for i in 0 ..< friendsArray.count{
            let friendDictionary:Dictionary<String,String> = friendsArray[i]
            let  friendName:String = friendDictionary["friendName"]!
            friendsNameArray.append(friendName)
        }
        util.printLog(viewC: self, tag: "友達一覧", contents: friendsNameArray)
        table?.reloadData()
        //トップに戻るボタンを作成
        let leftButton = UIBarButtonItem(title: "⬅︎", style: UIBarButtonItemStyle.plain, target: self, action: "goTop")
        self.navigationItem.leftBarButtonItem = leftButton
    }
    //トップに戻るボタン押下時の呼び出しメソッド
    func goTop() {
        
        //トップ画面に戻る。
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // セクション(グループの数)を返す　この場合arrayは設定 1〜3の３つのセクション
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セクションに入るセルの数を返す　-1 しているのは各セクションの一つ目の要素がタイトルヘッダーとなるためそれを除いている
        return friendsNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 各 Cellの設定をしている　今回はタイトル入力のみ
        
        cell.textLabel?.text = friendsNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //　タイトルヘッダーの要素を返している　今回は各セクションの先頭 0番目がヘッダーとなる
        return friendsSectionArray[0]
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



