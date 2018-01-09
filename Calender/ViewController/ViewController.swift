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


extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let dateManager = DateManager()
    let colorManager = ColorManeger()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 0
    var selectedDate = Date()
    var today: Date!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    @IBOutlet weak var headerPrevBtn: UIButton!//①
    @IBOutlet weak var headerNextBtn: UIButton!//②
    @IBOutlet weak var headerTitle: UILabel!    //③
    @IBOutlet weak var calenderHeaderView: UIView! //④
    @IBOutlet weak var calenderCollectionView: UICollectionView!//⑤
    @IBOutlet weak var nextlabel: UILabel!
    @IBOutlet weak var prevlabel: UILabel!
    
    var calenderCell:CalendarCell = CalendarCell()
    
    var colorNum:Int = 0
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    var year:String = ""
    var month:String = ""
    var date:String = ""
    
    //画面が消える時
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        // ナビバーの表示を切り替える
        if let nv = navigationController {
            nv.setNavigationBarHidden(true, animated: true)
        }
        
        
        calenderCollectionView.reloadData()
        
        
        self.calenderCell.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        calenderHeaderView.backgroundColor = colorManager.mainColor()[colorNum]
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.white
        
        headerTitle.adjustsFontSizeToFitWidth = true
        
        headerTitle.text = changeHeaderTitle(selectedDate) //追記
        
        //ボタンに前後月を表示
        let prevbackMonth = selectedDate.monthAgoDate()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        let prevbackMonthStr = formatter.string(from: prevbackMonth)
        prevlabel.text = formatter.string(from: prevbackMonth)
        
        let nextMonth = selectedDate.monthLaterDate()
        formatter.dateFormat = "M"
        let nextMonthStr = formatter.string(from: nextMonth)
        headerNextBtn.setTitle(nextMonthStr, for: UIControlState())
        nextlabel.text = formatter.string(from: nextMonth)
        
        
    }
    
    
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if section == 0 {
            return 7
        } else {
            return dateManager.numberOfItems//ここは月によって異なる(後ほど説明します)
        }
    }
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCell
        //テキストカラー
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.gray
        }
        //テキスト配置
        if indexPath.section == 0 {
            cell.textLabel.text = weekArray[indexPath.row]
            cell.textLabel.textAlignment = .center
        } else {
            let cellDate  = dateManager.currentMonthOfDates[indexPath.row]
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: cellDate)
            formatter.dateFormat = "MM"
            let month = formatter.string(from: cellDate)
            formatter.dateFormat = "dd"
            let date = formatter.string(from: cellDate)
            cell.textLabel.text = date
            cell.textLabel.textAlignment = .left
            //月によって1日の場所は異なる(後ほど説明します)
            
            //変更点（2017/07/13）
            cell.image.image = nil
            
            //変更点（2017/07/13）
            let realm = try! Realm()
            
            let text = String(year) + "/" + String(month) + "/" + String(date)

            print("aaa")
            print(text)
            if let diary = realm.objects(Diary.self).filter("date == %@", text).last{
                 print("bbb")
                print(diary)
                
                if diary.photo != nil {
                    cell.image.image = UIImage(data: diary.photo as! Data)
                    
                    print(indexPath.row)
                }
                
            }
            
        }
        
        
        
        
        
        return cell
    }
    
    //collectionViewのセルを押した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellDate  = dateManager.currentMonthOfDates[indexPath.row]
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        year = formatter.string(from: cellDate)
        formatter.dateFormat = "M"
        month = formatter.string(from: cellDate)
        formatter.dateFormat = "dd"
        date = formatter.string(from: cellDate)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        performSegue(withIdentifier: "EditController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditController" {
            
            let showController:ShowController = segue.destination as! ShowController
            
            // 変数:遷移先ViewController型 = segue.destinationViewController as 遷移先ViewController型
            // segue.destinationViewController は遷移先のViewController
            
            showController.year = self.year
            showController.month = self.month
            showController.date = self.date
        }
        
    }
    
    
    
    
    //①タップ時
    @IBAction func tappedHeaderPrevBtn(_ sender: UIButton) {
        dateManager.prevMonth()
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(dateManager.selectedDate)
        print("a")
        print(dateManager.selectedDate)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        let prevbackMonthStr = formatter.string(from: dateManager.selectedDate.monthAgoDate())
        headerPrevBtn.setTitle(prevbackMonthStr, for: UIControlState())
        prevlabel.text = prevbackMonthStr
        
        formatter.dateFormat = "M"
        let nextMonthStr = formatter.string(from: dateManager.selectedDate.monthLaterDate())
        headerNextBtn.setTitle(nextMonthStr, for: UIControlState())
        nextlabel.text = nextMonthStr
        
        //変更点（2017/07/13）
        calenderCollectionView.reloadData()
    }
    
    //②タップ時
    @IBAction func tappedHeaderNextBtn(_ sender: UIButton) {
        dateManager.nextMonth()
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(dateManager.selectedDate)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        let prevbackMonthStr = formatter.string(from: dateManager.selectedDate.monthAgoDate())
        headerPrevBtn.setTitle(prevbackMonthStr, for: UIControlState())
        prevlabel.text = prevbackMonthStr
        
        formatter.dateFormat = "M"
        let nextMonthStr = formatter.string(from: dateManager.selectedDate.monthLaterDate())
        headerNextBtn.setTitle(nextMonthStr, for: UIControlState())
        nextlabel.text = nextMonthStr
        
        //変更点（2017/07/13）
        calenderCollectionView.reloadData()
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
    
    //headerの月を変更
    func changeHeaderTitle(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy\nM"
        let selectMonth = formatter.string(from: date)
        return selectMonth
    }
    
}
