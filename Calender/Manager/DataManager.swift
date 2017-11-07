//
//  DateManager.swift
//  Calender
//
//  Created by Hazuki♪ on 1/31/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit

extension Date {
    func monthAgoDate() -> Date {
        let addValue = -1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    func monthLaterDate() -> Date {
        let addValue: Int = 1
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = addValue
        return (calendar as NSCalendar).date(byAdding: dateComponents, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
}

class DateManager: NSObject {
    var currentMonthOfDates = [Date]() //表記する月の配列
    var selectedDate : Date = Date()
    let daysPerWeek: Int = 7
    var numberOfItems: Int = 0
    var firstDateOfMonth :Date = Date()
    
    override init() {
        super.init()
        self.initiallize()
    }
    
    func initiallize(){
        
        firstDateOfMonth = firstDateOfMonth(selectedDate: self.selectedDate)
        numberOfItems = daysAcquisition(firstDateOfMonth: self.firstDateOfMonth)
        self.currentMonthOfDates = dateForCellAtIndexPath(firstDateOfMonth: self.firstDateOfMonth,numberOfItems: self.numberOfItems)
        
    }
    
    //月ごとのセルの数を返すメソッド
    func daysAcquisition(firstDateOfMonth : Date) -> Int {
        let rangeOfWeeks = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.weekOfMonth, in: NSCalendar.Unit.month, for: firstDateOfMonth)
        let numberOfWeeks = rangeOfWeeks.length //月が持つ週の数
        return numberOfWeeks * daysPerWeek //週の数×列の数
    }
    //月の初日を取得
    func firstDateOfMonth(selectedDate : Date) -> Date {
        print(selectedDate)
        var components = (Calendar.current as NSCalendar).components([.year, .month, .day],
                                                                     from: selectedDate)
        components.day = 1
        
        let firstDateMonth = Calendar.current.date(from: components)!
        print(firstDateMonth)
        print("day")
        
        return firstDateMonth
    }
    
    // ⑴カレンダーに表示する日付の取得
    func dateForCellAtIndexPath(firstDateOfMonth : Date,numberOfItems: Int)  -> [Date] {
        var currentMonthOfDates = [Date]()
        
        // ①「月の初日が週の何日目か」を計算する
        let ordinalityOfFirstDay = (Calendar.current as NSCalendar).ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.weekOfMonth, for: firstDateOfMonth)
        print(ordinalityOfFirstDay)
        for i in 0 ..< numberOfItems {
            // ②「月の初日」と「indexPath.item番目のセルに表示する日」の差を計算する
            var dateComponents = DateComponents()
            dateComponents.day = i - (ordinalityOfFirstDay - 1)
            // ③ 表示する月の初日から②で計算した差を引いた日付を取得
            let date = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: firstDateOfMonth, options: NSCalendar.Options(rawValue: 0))!
            // ④配列に追加
            currentMonthOfDates.append(date)
        }
        print(currentMonthOfDates)
        return currentMonthOfDates
    }
    //前月の表示
    func prevMonth(){
        selectedDate = selectedDate.monthAgoDate()
        initiallize()
        
    }
    //次月の表示
    func nextMonth(){
        selectedDate = selectedDate.monthLaterDate()
        initiallize()
        
    }
    
    
    
}
