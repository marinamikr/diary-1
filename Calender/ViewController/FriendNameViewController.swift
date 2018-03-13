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
    
}



