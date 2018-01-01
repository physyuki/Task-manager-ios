//
//  ManipulateRecord.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import RealmSwift

class ManipulateRecord {
    let realm = try! Realm()
    let now = Date()
    
    func recordTime (sender: UIButton, startTime: TimeInterval) {
        let record = Record()
        record.name = (realm.object(ofType: ItemInfo.self, forPrimaryKey: sender.tag)?.name)!
        record.start = startTime
        record.stop = now.timeIntervalSince1970
        record.date = FormatTime().dateFormat().string(from: now)
        try! realm.write() { realm.add(record) }
    }
    
    func getWeekData() -> [String: [Double]] {
        let itemInfo = ManipulateItem().getItemInfo()
        var recordtime:Double = 0
        var sumtime:[Double] = []
        var data = [String: [Double]]()
        
        for item in itemInfo {
            for i in 0...6 {
                let day = FormatTime().dateFormat().string(from: now - 60*60*24 * Double(6 - i))
                let records = realm.objects(Record.self).filter("date like '\(day)'").filter("name like '\(item[0])'")
                
                for record in records {
                    recordtime += Double(record.stop - record.start)/3600
                }
                sumtime.append(recordtime)
            }
            data[item[0] as! String] = sumtime
            recordtime = 0
            sumtime = []
        }
        return data
    }
    
    func getWeekDateInfo() -> [String] {
        var weekDateInfo = [String]()
        let f = FormatTime()
        //7日分の日付を生成
        for i in 0...6 {
            let date = f.getDayFormat().string(from: now - 60*60*24 * Double(6 - i))
            weekDateInfo.append(date)
            if i > 0 {//月初には月を表示、年初には年を表示
                if date == "1" {
                    let month = f.getMonthFormat().string(from: now - 60*60*24 * Double(6 - i))
                    weekDateInfo[i] = weekDateInfo[i] + "\n" + month
                    if month == "1月" {//ここは海外向けに修正すべき
                        let year = f.getYearFormat().string(from: now - 60*60*24 * Double(6 - i))
                        weekDateInfo[i] = weekDateInfo[i] + "\n" + year
                    }
                }
            }
        }
        //最初のデータには必ず月と年を表示
        let month = f.getMonthFormat().string(from: now - 60*60*24 * Double(6))
        weekDateInfo[0] = weekDateInfo[0] + "\n" + month
        let year = f.getYearFormat().string(from: now - 60*60*24 * Double(6))
        weekDateInfo[0] = weekDateInfo[0] + "\n" + year
        
        return weekDateInfo
    }
    
}
