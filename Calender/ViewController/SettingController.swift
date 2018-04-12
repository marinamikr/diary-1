    //
    //  SettingViewController.swift
    //  Calender
    //
    //  Created by Hazuki♪ on 2017/06/20.
    //  Copyright © 2017年 hazuki. All rights reserved.
    //
    
    import UIKit
    import RealmSwift
    import Firebase
    
    class SettingController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UINavigationControllerDelegate{
        
        @IBOutlet weak var table: UITableView!
        var array =  [ ["COLORS","Red",  "Pink", "Orange", "Yellow", "Green","Blue","Purple"],
                       ["DELETE", "AllDelete"],
                       ["CHANGE", "MyQR", "AddFriend","FriendsList",""],
                       ["HELP", "HowToUse", "Question",],
                       ]
        
        var checkArr = [true,false,false,false,false,false,false]
        
        var colorNumber: Int = 0
        
        let colorManager = ColorManeger()
        
        
        
        var userDefaults:UserDefaults = UserDefaults.standard
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            table?.delegate = self
            table?.dataSource = self
            table?.backgroundColor = UIColor.white
            table?.allowsMultipleSelection = false
            navigationController?.delegate = self
            
            let nib = UINib(nibName: "CustumSettingTableViewCell", bundle:nil)
            table.register(nib, forCellReuseIdentifier: "custumSettingTableViewCell")
            
            let nib2 = UINib(nibName: "CustomSwitchTableViewCell", bundle:nil)
            table.register(nib2, forCellReuseIdentifier: "customSwitchTableViewCell")
            
            
            
            if userDefaults.object(forKey: "CHECK") != nil {
                checkArr = userDefaults.object(forKey: "CHECK") as! [Bool]
            }
            
            if userDefaults.object(forKey: "COLOR") != nil {
                self.colorNumber = userDefaults.object(forKey: "COLOR") as! Int
                navigationController?.navigationBar.backgroundColor = colorManager.mainColor()[self.colorNumber]
            }else {
                navigationController?.navigationBar.backgroundColor = colorManager.mainColor()[self.colorNumber]
            }
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            if userDefaults.object(forKey: "CHECK") != nil {
                checkArr = userDefaults.object(forKey: "CHECK") as! [Bool]
            }
        }
        
        @IBAction func save() {
            userDefaults.set(checkArr, forKey: "CHECK")
            userDefaults.set(colorNumber, forKey: "COLOR")
            
            let alert = UIAlertController(title: "保存完了",
                                          message: "保存が完了しました",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title :"OK",
                                          style :.default,
                                          handler: {action in
                                            
            }))
            
            present(alert, animated: true,completion: nil)
        }
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // セクション(グループの数)を返す　この場合arrayは設定 1〜3の３つのセクション
            return array.count
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // セクションに入るセルの数を返す　-1 しているのは各セクションの一つ目の要素がタイトルヘッダーとなるためそれを除いている
            return array[section].count - 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.section != 2 || indexPath.row != 3{
                let cell = table.dequeueReusableCell(withIdentifier: "custumSettingTableViewCell") as! CustumSettingTableViewCell
                
                // 各 Cellの設定をしている　今回はタイトル入力のみ
                
                cell.setText(text:array[indexPath.section][indexPath.row + 1])
                
                if indexPath.section == 0 {
                    if checkArr[indexPath.row] {
                        cell.check.alpha = 1
                    }else{
                        cell.check.alpha = 0
                    }
                }else{
                    cell.check.alpha = 0
                }
                
                return cell
            }else{
                
                let cell = table.dequeueReusableCell(withIdentifier: "customSwitchTableViewCell") as! CustomSwitchTableViewCell
                return cell
            }
        }
        
        //        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //            //　タイトルヘッダーの要素を返している　今回は各セクションの先頭 0番目がヘッダーとなる
        //            return array[section][0]
        //        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            
            if indexPath.section == 0{
                colorNumber = indexPath.row
                
                for i in 0..<checkArr.count {
                    if checkArr[i] == true {
                        checkArr[i] = false
                    }
                    
                    if i == indexPath.row {
                        checkArr[i] = true
                        navigationController?.navigationBar.backgroundColor = colorManager.mainColor()[indexPath.row]
                    }
                }
                userDefaults.set(checkArr, forKey: "CHECK")
                userDefaults.set(colorNumber, forKey: "COLOR")
                tableView.reloadData()
                
            }else if indexPath.section == 1{
                let alert: UIAlertController = UIAlertController(title: "全削除", message: "今までの日記が全て消えます", preferredStyle: .alert)
                
                // ② Actionの設定
                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                // OKボタン
                
                
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    
                    // Realmのインスタンスを取得
                    let realm = try! Realm()
                    try! realm.write() {
                        realm.deleteAll()
                    }
                    
                    let uuid = UIDevice.current.identifierForVendor!.uuidString
                    let lef = Database.database().reference()
                    var handle = lef.child("UserIDArray").observe(.childAdded, with: { [weak self](snapshot) -> Void in
                        
                        print(snapshot.key)
                        let id = String(describing: snapshot.childSnapshot(forPath: "userID").value!)
                        if id == uuid{
                            lef.child("UserIDArray").child(snapshot.key).removeValue()
                        }
                    })
                    lef.child("UserIDArray").removeObserver(withHandle: handle)
                    
                    lef.child(uuid).removeValue()
                    self.userDefaults.set(false, forKey: "SENT_USERID")
                    
                })
                // キャンセルボタン
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                })
                
                // ③ UIAlertControllerにActionを追加
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
            }else if indexPath.section == 2{
                
                if indexPath.row == 0{
                    performSegue(withIdentifier: "myqr", sender: nil)
                }
                else if indexPath.row == 1{
                    performSegue(withIdentifier: "friends", sender: nil)
                }
                else if indexPath.row == 2{
                    performSegue(withIdentifier: "friendsNameViewController", sender: nil)
                }
            }else if indexPath.section == 3{
                
                if indexPath.row == 0{
                    performSegue(withIdentifier: "howTo", sender: nil)
                }
            }
            
            
            
        }
        
        
        // セルの選択が外れた時に呼び出される
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)
            checkArr[indexPath.row] = !checkArr[indexPath.row]
            tableView.reloadData()
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 65
        }
        //
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
        {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
            let label : UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width, height: 30))
            
            label.textColor = UIColor.black
            label.text = array[section][0]
            
            headerView.addSubview(label)
            
            headerView.backgroundColor = UIColor.white
            return headerView
        }
        //
        
        
    }
    
    
