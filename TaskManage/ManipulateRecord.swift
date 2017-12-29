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
        let f = DateFormatter()
        //7日分の日付を生成
        for i in 0...6 {
            f.dateFormat = "d"
            let date = f.string(from: now - 60*60*24 * Double(17 - i))//to6
            weekDateInfo.append(date)
            if i > 0 {//月初には月を表示
                if date == "1" {
                    f.dateFormat = "MMM"
                    f.locale = Locale(identifier: "ja_JP")
                    let month = f.string(from: now - 60*60*24 * Double(17 - i))
                    //年初には年を表示
                    weekDateInfo[i] = weekDateInfo[i] + "\n" + month
                }
            }
        }
        //最初のデータには月と年を表示
        f.dateFormat = "MMM"
        f.locale = Locale(identifier: "ja_JP")
        let month = f.string(from: now - 60*60*24 * Double(17))
        weekDateInfo[0] = weekDateInfo[0] + "\n" + month
        f.dateFormat = "y"
        let year = f.string(from: now - 60*60*24 * Double(17))
        weekDateInfo[0] = weekDateInfo[0] + "\n" + year
        
        return weekDateInfo
    }
    
}
