//
//  ViewController.swift
//  Calender
//
//  Created by Hazuki♪ on 1/31/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit



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
   
    var colorNum:Int = 0
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    //画面が消える時
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int

        }
        
        switch colorNum {
            case 0:
                headerNextBtn.setImage(UIImage(named: "red.png") , for : .normal)
                headerPrevBtn.setImage(UIImage(named: "red_back.png") , for: .normal)
            
        case 1:
            headerNextBtn.setImage(UIImage(named: "pink.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "pink_back.png") , for: .normal)
            
        case 2:
            headerNextBtn.setImage(UIImage(named: "orange.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "orange_back.png") , for: .normal)
            
        case 3:
            headerNextBtn.setImage(UIImage(named: "yellow.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "yellow_back.png") , for: .normal)
        
        case 4:
            headerNextBtn.setImage(UIImage(named: "green.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "green_back.png") , for: .normal)
            
        case 5:
            headerNextBtn.setImage(UIImage(named: "blue.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "blue_back.png") , for: .normal)
        
        case 6:
            headerNextBtn.setImage(UIImage(named: "purpre.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "purpure_back.png") , for: .normal)
      
        default:
            return
        }
        
        
        
        calenderHeaderView.backgroundColor = colorManager.mainColor()[colorNum]
        // ナビバーの表示を切り替える
        if let nv = navigationController {
            nv.setNavigationBarHidden(true, animated: true)
        }
        
        calenderCollectionView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }
        
        switch colorNum {
        case 0:
            headerNextBtn.setImage(UIImage(named: "red.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "red_back.png") , for: .normal)
            
        case 1:
            headerNextBtn.setImage(UIImage(named: "pink.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "pink_back.png") , for: .normal)
            
        case 2:
            headerNextBtn.setImage(UIImage(named: "orange.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "orange_back.png") , for: .normal)
            
        case 3:
            headerNextBtn.setImage(UIImage(named: "yellow.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "yellow_back.png") , for: .normal)
            
        case 4:
            headerNextBtn.setImage(UIImage(named: "green.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "green_back.png") , for: .normal)
            
        case 5:
            headerNextBtn.setImage(UIImage(named: "blue.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "blue_back.png") , for: .normal)
            
        case 6:
            headerNextBtn.setImage(UIImage(named: "purpre.png") , for : .normal)
            headerPrevBtn.setImage(UIImage(named: "purpure_back.png") , for: .normal)
            
        default:
            return
        }

        
        calenderHeaderView.backgroundColor = colorManager.mainColor()[colorNum]
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        calenderCollectionView.backgroundColor = UIColor.white
        
        headerTitle.adjustsFontSizeToFitWidth = true
        
        headerTitle.text = changeHeaderTitle(selectedDate) //追記
      
        //ボタンに前後月を表示
        let prevbackMonth = dateManager.prevMonth(selectedDate)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        let prevbackMonthStr = formatter.string(from: prevbackMonth)
        prevlabel.text = formatter.string(from: prevbackMonth)
        
        let nextMonth = dateManager.nextMonth(selectedDate)
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
            return dateManager.daysAcquisition() //ここは月によって異なる(後ほど説明します)
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
            cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
            cell.textLabel.textAlignment = .left
            
            //月によって1日の場所は異なる(後ほど説明します)
        }
        
        
        
        
        return cell
    }
    
    //collectionViewのセルを押した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: selectedDate)
        formatter.dateFormat = "M"
        let month = formatter.string(from: selectedDate)
        let day = dateManager.conversionDateFormat(indexPath)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.year = year //appDelegateの変数を操作
        appDelegate.month = month
        appDelegate.date = day
        
        
        performSegue(withIdentifier: "EditController", sender: self)
    }
    
  


    //①タップ時
    @IBAction func tappedHeaderPrevBtn(_ sender: UIButton) {
        selectedDate = dateManager.prevMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
        
        let prevbackMonth = dateManager.prevMonth(selectedDate)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        let prevbackMonthStr = formatter.string(from: prevbackMonth)
        headerPrevBtn.setTitle(prevbackMonthStr, for: UIControlState())
        prevlabel.text = formatter.string(from: prevbackMonth)
        
        let nextMonth = dateManager.nextMonth(selectedDate)
        formatter.dateFormat = "M"
        let nextMonthStr = formatter.string(from: nextMonth)
        headerNextBtn.setTitle(nextMonthStr, for: UIControlState())
        nextlabel.text = formatter.string(from: nextMonth)
        
    }
    
    //②タップ時
    @IBAction func tappedHeaderNextBtn(_ sender: UIButton) {
        selectedDate = dateManager.nextMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
      
        let prevbackMonth = dateManager.prevMonth(selectedDate)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        let prevbackMonthStr = formatter.string(from: prevbackMonth)
        headerPrevBtn.setTitle(prevbackMonthStr, for: UIControlState())
        prevlabel.text = formatter.string(from: prevbackMonth)
        
        let nextMonth = dateManager.nextMonth(selectedDate)
        formatter.dateFormat = "M"
        let nextMonthStr = formatter.string(from: nextMonth)
        headerNextBtn.setTitle(nextMonthStr, for: UIControlState())
        nextlabel.text = formatter.string(from: nextMonth)

    }
    
    
    //セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        var height: CGFloat = width * 1.5
        
        if indexPath.section == 0 {
            height = width*0.7
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
