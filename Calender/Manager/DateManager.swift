//
//  DateManager.swift
//  Calender
//
//  Created by Hazuki♪ on 1/31/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit



class DateManager: NSObject {
    
    
    var today : Date = Date()//今日の日付
    var firstDateOfMonth :Date = Date()//月の最初の日付
    let daysPerWeek: Int = 7//一週間の日付の数
    var numberOfItems: Int = 0//CollectionViewのセルの数
    var currentMonthOfDates = [Date]() //表示する月の、すべての日付を持つ配列
    
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    
    override init() {
        super.init()
        self.initiallize()
    }
    
    //初期化処理
    func initiallize(){
        //今日の日付から、月の最初の日付を取得
        self.firstDateOfMonth = firstDateOfMonth(today: self.today)
        //月の最初の日付から、CollectionViewのセルの数を取得
        self.numberOfItems = daysAcquisition(firstDateOfMonth: self.firstDateOfMonth)
        //表示する月の、すべての日付を持つ配列を作成する
        self.currentMonthOfDates = dateForCellAtIndexPath(firstDateOfMonth: self.firstDateOfMonth,numberOfItems: self.numberOfItems)
        
    }
    //月の最初の日付を、今日の日付から計算する
    func firstDateOfMonth(today : Date) -> Date {
        var components = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                                     from: self.today)
        components.day = 1
        let firstDateOfMonth = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    //月の最初の日付から、CollectionViewのセルの数を計算する
    func daysAcquisition(firstDateOfMonth : Date) -> Int {
        let rangeOfWeeks = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.weekOfMonth, in: NSCalendar.Unit.month, for: firstDateOfMonth)
        let numberOfWeeks = rangeOfWeeks.length //月が持つ週の数
        return numberOfWeeks * self.daysPerWeek //週の数×列の数
    }
   
    
    //表示する月の、すべての日付を持つ配列を作成
    func dateForCellAtIndexPath(firstDateOfMonth : Date,numberOfItems: Int)  -> [Date] {
        var currentMonthOfDates = [Date]()
        
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = (Calendar.current as NSCalendar).ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.weekOfMonth, for: firstDateOfMonth)
        for i in 0 ..< numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: firstDateOfMonth, options: NSCalendar.Options(rawValue: 0))!
            // ④配列に追加
            currentMonthOfDates.append(date)
        }
        return currentMonthOfDates
    }
    //１ヶ月前の情報に更新
    func changePreMonth(){
        self.today = today.monthAgoDate()
        initiallize()
    }
    //１ヶ月後の情報に更新
    func changeNextMonth(){
        self.today = today.monthLaterDate()
        initiallize()
    }
    
}
