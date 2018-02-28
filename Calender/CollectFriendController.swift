////
////  CollectFriendController.swift
////  Calender
////
////  Created by Hazuki♪ on 2018/02/20.
////  Copyright © 2018年 hazuki. All rights reserved.
////
//
//import UIKit
//
//class CollectFriendController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}








//適当に書いてみた↓↓





//
//  SettingViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 2017/06/20.
//  Copyright © 2017年 hazuki. All rights reserved.
//

import UIKit
import RealmSwift

class CollectFriendController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UINavigationControllerDelegate{
    
    var array = [ ["友達一覧"],
                  ]
    
    
    var colorNumber: Int = 0
    
    let colorManager = ColorManeger()
    
    
    @IBOutlet var table:UITableView? = UITableView()
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table?.delegate = self
        table?.dataSource = self
        table?.backgroundColor = UIColor.white
        table?.allowsMultipleSelection = false
        navigationController?.delegate = self
        
        
      
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 各 Cellの設定をしている　今回はタイトル入力のみ
        
        cell.textLabel?.text = array[indexPath.section][indexPath.row + 1]
        
        if indexPath.section == 0 {
           
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
          
                }
        
        
            
            
        
    
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
}




}


