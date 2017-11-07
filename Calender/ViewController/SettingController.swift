//
//  SettingViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 2017/06/20.
//  Copyright © 2017年 hazuki. All rights reserved.
//

import UIKit
import RealmSwift

class SettingController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UINavigationControllerDelegate{
    
    var array = [ ["Colors","red",  "pink", "orange", "yellow", "green","blue","purple"],
                  
                  ["日記削除", "all delete"],
                  
                  ]
    
    var checkArr = [true,false,false,false,false,false,false]
    
    var colorNumber: Int = 0
    
    let colorManager = ColorManeger()
    
    
    @IBOutlet var table:UITableView? = UITableView()
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table?.delegate = self
        table?.dataSource = self
        
        navigationController?.delegate = self
        
        
        table?.backgroundColor = UIColor.white
        
        table?.allowsMultipleSelection = false
        
        if userDefaults.object(forKey: "CHECK") != nil {
            checkArr = userDefaults.object(forKey: "CHECK") as! [Bool]
            
        }
        
        if userDefaults.object(forKey: "COLOR") != nil {
            navigationController?.navigationBar.backgroundColor = colorManager.mainColor()[userDefaults.object(forKey: "COLOR") as! Int]
        }else {
            navigationController?.navigationBar.backgroundColor = colorManager.mainColor()[colorNumber]
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.object(forKey: "CHECK") != nil {
            checkArr = userDefaults.object(forKey: "CHECK") as! [Bool]
            
        }
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
        // #warning Incomplete implementation, return the number of sections
        // セクション(グループの数)を返す　この場合arrayは設定 1〜3の３つのセクション
        return array.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // セクションに入るセルの数を返す　-1 しているのは各セクションの一つ目の要素がタイトルヘッダーとなるためそれを除いている
        return array[section].count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        
        // Configure the cell...
        // 各 Cellの設定をしている　今回はタイトル入力のみ
        // print()を使って確かめてみるとわかるが、このメソッドはCellの数だけ呼び出されている
        print(indexPath.section)
        
        cell.textLabel?.text = array[indexPath.section][indexPath.row + 1]
        
        if indexPath.section == 0 {
            if checkArr[indexPath.row] {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //　タイトルヘッダーの要素を返している　今回は各セクションの先頭 0番目がヘッダーとなる
        return array[section][0]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルが選択された時に呼び出される
        let cell = tableView.cellForRow(at:indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        colorNumber = indexPath.row
        
        if indexPath.section == 0{
            for i in 0..<checkArr.count {
                if checkArr[i] == true {
                    checkArr[i] = false
                }
                
                if i == indexPath.row {
                    checkArr[i] = true
                    
                    navigationController?.navigationBar.backgroundColor = colorManager.mainColor()[indexPath.row]
                    
                    
                }
            }
        }else if indexPath.section == 1{
            let alert: UIAlertController = UIAlertController(title: "全削除", message: "いいですか", preferredStyle: .alert)
            print("全削除します")
            // ② Actionの設定
            // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
            // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
            // OKボタン
            
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                
                // Realmのインスタンスを取得
                let realm = try! Realm()
                
                // Realmに保存されてるDog型のオブジェクトを全て取得
                let dogs = realm.objects(Diary)
                
                //                // 一番後ろの犬を取り出し
                //                if let dog = dogs.last {
                //
                // さようなら・・・
                try! realm.write() {
                    realm.deleteAll()
                }
                print("OK")
                
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
        userDefaults.set(checkArr, forKey: "CHECK")
        userDefaults.set(colorNumber, forKey: "COLOR")
        
        tableView.reloadData()
        
        
    }
    
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        checkArr[indexPath.row] = !checkArr[indexPath.row]
        
        
        tableView.reloadData()
        
        //        let cell = tableView.cellForRow(at:indexPath)
        //
        //        if cell?.accessoryType == .checkmark {
        //
        //
        //            cell?.accessoryType = .none
        //
        //        }
    }
}
