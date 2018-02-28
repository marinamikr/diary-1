//
//  ViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 1/31/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase




class ViewController: UIViewController{
    
    /*View関連の変数*/
    @IBOutlet weak var headerPrevBtn: UIButton!//一月前に移動するボタン
    @IBOutlet weak var headerNextBtn: UIButton!//一月後に移動するボタン
    @IBOutlet weak var headerTitle: UILabel!    //表示している月を表示するボタン
    @IBOutlet weak var calenderHeaderView: UIView! //CollectionViewのヘッダー
    @IBOutlet weak var calenderCollectionView: UICollectionView!//CollectionView自体
    @IBOutlet weak var nextlabel: UILabel!//一月後に移動するボタンのlabel
    @IBOutlet weak var prelabel: UILabel!//一月前に移動するボタンのlabel
    
    
    //日付を管理するManeger
    let dateManager = DateManager()
    //色を管理するManeger
    let colorManager = ColorManeger()
    //NSUserDefaults
    var userDefaults:UserDefaults = UserDefaults.standard
    
    var IDArray:[String] = Array()
    
    //CollectionViewのExtentionで使用する変数
    var cellMargin: CGFloat = 0
    var daysPerWeek: Int = 7
    var selectedDate:Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUserData()
        // ナビバーの表示を切り替える
        if let nv = navigationController {
            nv.setNavigationBarHidden(true, animated: true)
        }
        
        //collectionViewのdelegateの指定と、背景色の指定
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.white
        calenderCollectionView.register(UINib(nibName: "CalendarCustomCell", bundle: nil), forCellWithReuseIdentifier: "calendarCustomCell")
        
        //ヘッダーの指定
        headerTitle.text = dateManager.firstDateOfMonth.toMonthString()
        prelabel.text = dateManager.firstDateOfMonth.monthAgoDate().toMonthString()
        nextlabel.text = dateManager.firstDateOfMonth.monthLaterDate().toMonthString()
        
        //色の設置をする
        setLayoutColor()
        
        //最初の一回のみ
        let sentUserId = userDefaults.bool(forKey: "SENT_USERID")
        if sentUserId == false {
            addMyID()
            userDefaults.set(true, forKey: "SENT_USERID")
        }
        
    }
    
    func addMyID(){
        // databaseから画像の名前を取得
        let ref = Database.database().reference().child("UserridDArray")
        let data : Dictionary = ["userName":"hazuki","userID":UIDevice.current.identifierForVendor!.uuidString,]
        
        //トップReferenceの一つ下の固有IDの枝に、key value形式の情報を送る
        ref.childByAutoId().setValue(data)
        
        
        ref.observe(DataEventType.value, with: { snapshot in
            for i in 0 ..< Int(snapshot.childrenCount) {
                //IDArray.append(snapshot.childSnapshot(forPath: """"))
            }
            
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayoutColor()//色の設置をする
        calenderCollectionView.reloadData()
    }
    
    
    //１ヶ月前に戻るボタンをタップした時の処理
    @IBAction func tappedHeaderPrevBtn(_ sender: UIButton) {
        
        //まず、DateManagerの情報を１ヶ月前に変更
        dateManager.changePreMonth()
        
        //ヘッダーの更新
        headerTitle.text = dateManager.firstDateOfMonth.toMonthString()
        prelabel.text = dateManager.firstDateOfMonth.monthAgoDate().toMonthString()
        nextlabel.text = dateManager.firstDateOfMonth.monthLaterDate().toMonthString()
        
        //変更点（2017/07/13）
        //CollectionViewの更新
        calenderCollectionView.reloadData()
    }
    
    
   /* func setUserData(){
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let ref = Database.database().reference().child("allUser")
        
        
        ref.observe(DataEventType.value, with: { snapshot in
            
            
            
            let postDict = snapshot.value  as! [String : AnyObject]
                print(postDict)
                for (key, value) in postDict {
                    if (key == "allUser"){
                        var allArray = value as! Array<String>
                        
                        if !(allArray.contains(uuid)){
                            allArray.append(uuid)
                            ref.child("allUser").setValue(allArray)
                        }
                        
                    }
                }
                
            }
            
        })
        
        
        
    }
 */
    //１ヶ月後に移動するボタンをタップした時の処理
    @IBAction func tappedHeaderNextBtn(_ sender: UIButton) {
        //まず、DateManagerの情報を１ヶ月後に変更
        dateManager.changeNextMonth()
        
        //ヘッダーの更新
        headerTitle.text = dateManager.firstDateOfMonth.toMonthString()
        prelabel.text = dateManager.firstDateOfMonth.monthAgoDate().toMonthString()
        nextlabel.text = dateManager.firstDateOfMonth.monthLaterDate().toMonthString()
        
        //変更点（2017/07/13）
        //CollectionViewの更新
        calenderCollectionView.reloadData()
    }
    
    @IBAction func add(_ sender: Any) {
        performSegue(withIdentifier:  "toEditViewController", sender: nil)
    }
    
    //レイアウトの色を指定する
    func  setLayoutColor() {
        
        var colorNum = 0
        
        //NSUserDefaultsから、ユーザーの指定している色の情報を取得
        if let color = userDefaults.object(forKey: "COLOR") {
            colorNum = color as! Int
        }
        
        switch colorNum {
        case 0:
            headerNextBtn.setImage(UIImage(named: "redのコピー.png"), for: .normal)
            headerPrevBtn.setImage(UIImage(named: "red.png"), for: .normal)
            calenderCollectionView.layer.borderColor = UIColor(red:1.0,green:0.894, blue:0.882, alpha:1.0).cgColor
        case 1:
            headerNextBtn.setImage(UIImage(named: "矢印.png"), for: .normal)
            headerPrevBtn.setImage(UIImage(named: "矢印i.png"), for: .normal)
            calenderCollectionView.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
        case 2:
            headerNextBtn.setImage(UIImage(named: "orangeのコピー.png"), for: .normal)
            headerPrevBtn.setImage(UIImage(named: "orange.png"), for: .normal)
            calenderCollectionView.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 3:
            headerNextBtn.setImage(UIImage(named: "yellowのコピー.png"), for: .normal)
            headerPrevBtn.setImage(UIImage(named: "yellow.png"), for: .normal)
            calenderCollectionView.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 4:
            headerNextBtn.setImage(UIImage(named: "greenのコピー.png"), for: .normal)
            headerPrevBtn.setImage(UIImage(named: "green.png"), for: .normal)
            calenderCollectionView.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 5:
            headerNextBtn.setImage(UIImage(named: "blueのコピー.png"), for: .normal)
            headerPrevBtn.setImage(UIImage(named: "blue.png"), for: .normal)
            calenderCollectionView.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        case 6:
            headerNextBtn.setImage(UIImage(named: "purpleのコピー.png"), for: .normal)
            headerPrevBtn.setImage(UIImage(named: "purple.png"), for: .normal)
            calenderCollectionView.layer.borderColor = UIColor(red:0,green:0, blue:0, alpha:1.0).cgColor
            
        default:
            return
        }
        
        calenderHeaderView.backgroundColor = colorManager.mainColor()[colorNum]
    }
    
}


extension ViewController :UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //CollectionViewのSectionの数を指定する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //CollectionViewのCell数を指定する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える。
        if section == 0 {
            //曜日を表すSectionでは、曜日の数=7を指定する
            return 7
        } else if section == 1{
            //日付を表すcellの個数は、DateManegerから取得
            return dateManager.numberOfItems
        }else{
            return 0
        }
    }
    
    //CollectionViewのCellを作成する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //カスタムCellを取得【CalendarCell型】
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCustomCell",for: indexPath) as! CalendarCustomCell
        
        //テキストカラーの指定
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed() //日曜日は赤
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()//土曜日は青
        } else {
            cell.textLabel.textColor = UIColor.gray//他は灰色
        }
        
        
        //テキストの文字を指定
        if indexPath.section == 0 {
            cell.textLabel.text = dateManager.weekArray[indexPath.row]
            cell.textLabel.textAlignment = .center
        } else {
            
            //一度、画像を削除
            cell.imageView.image = UIImage()
            
            //セルに表示する日付の情報を取得
            let cellDate  = dateManager.currentMonthOfDates[indexPath.row]
            
            //セルに日付を表示
            cell.textLabel.text = cellDate.toDayString()
            cell.textLabel.textAlignment = .left
            
            //Realmオブジェクトの取得
            let realm = try! Realm()
            //Realmから、dateの情報が、Cellに表示する日付と一致するものを検索
            if let diary = realm.objects(Diary.self).filter("date == %@", cellDate.toString()).last{
                
                //もし、dateの情報が、Cellに表示する日付と一致するデータの中に、画像の情報が存在したら
                if diary.photo != nil {
                    cell.imageView.image = UIImage(data: diary.photo as! Data)
                }
            }
        }
        
        return cell
    }
    
    //セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        var height: CGFloat = width * 1.53
        
        if indexPath.section == 0 {
            height = width*0.6
        }
        
        return CGSize(width: width, height: height)
    }
    
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellMargin
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellMargin
    }
    
    
    //collectionViewのセルを押した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //選ばれたCellの、日付の情報を取得し、selectedDateに代入
        let cellDate  = dateManager.currentMonthOfDates[indexPath.row]
        self.selectedDate = cellDate
        //画面遷移
        performSegue(withIdentifier: "toShowController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toShowController" {
            //画面遷移前に、選ばれたCellの日付の情報をShowControllerに渡しておく
            let showController:ShowController = segue.destination as! ShowController
            showController.selectedDate = self.selectedDate
            showController.selectedDateString = self.selectedDate.toString()
        }
        
    }
}
