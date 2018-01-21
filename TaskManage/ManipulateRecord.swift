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
    
    func recordTime (sender: UIButton, startTime: Date) {
        let record = Record()
        record.name = realm.object(ofType: ItemInfo.self, forPrimaryKey: sender.tag)!.name
        record.start = startTime
        record.stop = now
        record.date = FormatTime().dateFormat().string(from: now)
        try! realm.write() { realm.add(record) }
    }
    
    func deleteRecord(_ name: String) {
        let names = realm.objects(Record.self).filter("name like '\(name)'")
        names.forEach { name in try! realm.write() {realm.delete(name)}}
    }
    
    func updateRecord(key: Int, _ preUpdate: Date, update: Date, witchTime: String) {
        let name = realm.object(ofType: ItemInfo.self, forPrimaryKey: key)!.name
        switch witchTime {
        case "start":
            let preUpdate = realm.objects(Record.self).filter("name like '\(name)' && start == %@", preUpdate)
            try! realm.write() {
                preUpdate.first?.start = update
            }
        case "stop":
            let preUpdate = realm.objects(Record.self).filter("name like '\(name)' && stop == %@", preUpdate)
            try! realm.write() {
                let updateData = preUpdate.first
                updateData?.stop = update
                updateData?.date = FormatTime().dateFormat().string(from: update)
            }
        default:
            break
        }
    }
    
    func getRecord(name: String) -> [[Date]] {
        var records = [[Date]]()
        let results = realm.objects(Record.self).filter("name like '\(name)'")
        for result in results {
            records.append([result.start, result.stop])
        }
        return records
    }
    
    func getWeekData() -> [String: [Double]] {
        let itemInfo = ManipulateItem().getItemInfo()
        var recordtime:Double = 0
        var sumtime = [Double](repeating: 0.0, count: 7)
        var data = [String: [Double]]()
        
        for item in itemInfo {
            for i in 0...6 {
                let day = FormatTime().dateFormat().string(from: now - 60*60*24 * Double(6 - i))
                let records = realm.objects(Record.self).filter("date like '\(day)'").filter("name like '\(item[0])'")
                
                for record in records {
                    let calendar = Calendar.current
                    var sameDayFlag = calendar.compare(record.start, to: record.stop, toGranularity: .day) == .orderedSame
                    if sameDayFlag {//記録が日をまたがない場合の計算
                        let diff = calendar.dateComponents([.second], from: record.start, to: record.stop)
                        recordtime = Double(diff.second!)/60
                        sumtime[i] += recordtime
                    }
                    //記録が日をまたいだ場合の計算
                    var hour = calendar.component(.hour, from: record.stop)
                    var minute = calendar.component(.minute, from: record.stop)
                    var beforeDay = 0
                    var beforeDayCount = 0
                    var recordEnd = record.stop
                    while !sameDayFlag {
                        let diffData = DateComponents(day: -beforeDay, hour: -hour, minute: -minute)
                        let dayEnd = calendar.date(byAdding: diffData, to: recordEnd)!
                        hour = 0
                        minute = 0
                        if beforeDay == 0 {//初回だけ当日0時に調整
                            beforeDay += 1
                        }
                        sameDayFlag = calendar.compare(record.start, to: dayEnd, toGranularity: .day) == .orderedSame
                        if sameDayFlag {
                            let diff = calendar.dateComponents([.second], from: record.start, to: dayEnd + 24 * 60  * 60)
                            recordtime = Double(diff.second!)/60
                        } else {
                            let diff = calendar.dateComponents([.second], from: dayEnd, to: recordEnd)
                            recordtime = Double(diff.second!)/60
                        }
                        if i - beforeDayCount >= 0 {//一週間以上前のデータは計算対象外
                            sumtime[i - beforeDayCount] += recordtime
                        }
                        beforeDayCount += 1
                        recordEnd = dayEnd
                    }
                }
            }
            for i in 1...6 {//累積値に変換
                sumtime[i] = sumtime[i] + sumtime[i - 1]
            }
            data[item[0] as! String] = sumtime
            sumtime = [Double](repeating: 0.0, count: 7)
        }
        return data
    }
    
    func getWeekSumData(dayNumber: Int) -> [String: Double] {
        let itemInfo = ManipulateItem().getItemInfo()
        var recordtime:Double = 0
        var sumtime = [Double](repeating: 0.0, count: dayNumber)
        var data = [String: Double]()
        
        for item in itemInfo {
            for i in 0...(dayNumber - 1) {
                let day = FormatTime().dateFormat().string(from: now - 60*60*24 * Double((dayNumber - 1) - i))
                let records = realm.objects(Record.self).filter("date like '\(day)'").filter("name like '\(item[0])'")
                
                for record in records {
                    let calendar = Calendar.current
                    var sameDayFlag = calendar.compare(record.start, to: record.stop, toGranularity: .day) == .orderedSame
                    if sameDayFlag {//記録が日をまたがない場合の計算
                        let diff = calendar.dateComponents([.second], from: record.start, to: record.stop)
                        recordtime = Double(diff.second!)/60
                        sumtime[i] += recordtime
                    }
                    //記録が日をまたいだ場合の計算
                    var hour = calendar.component(.hour, from: record.stop)
                    var minute = calendar.component(.minute, from: record.stop)
                    var beforeDay = 0
                    var beforeDayCount = 0
                    var recordEnd = record.stop
                    while !sameDayFlag {
                        let diffData = DateComponents(day: -beforeDay, hour: -hour, minute: -minute)
                        let dayEnd = calendar.date(byAdding: diffData, to: recordEnd)!
                        hour = 0
                        minute = 0
                        if beforeDay == 0 {//初回だけ当日0時に調整
                            beforeDay += 1
                        }
                        sameDayFlag = calendar.compare(record.start, to: dayEnd, toGranularity: .day) == .orderedSame
                        if sameDayFlag {
                            let diff = calendar.dateComponents([.second], from: record.start, to: dayEnd + 24 * 60  * 60)
                            recordtime = Double(diff.second!)/60
                        } else {
                            let diff = calendar.dateComponents([.second], from: dayEnd, to: recordEnd)
                            recordtime = Double(diff.second!)/60
                        }
                        if i - beforeDayCount >= 0 {//一週間以上前のデータは計算対象外
                            sumtime[i - beforeDayCount] += recordtime
                        }
                        beforeDayCount += 1
                        recordEnd = dayEnd
                    }
                }
            }
            if dayNumber > 1 {
                for i in 1...(dayNumber - 1) {//累積値に変換
                    sumtime[i] = sumtime[i] + sumtime[i - 1]
                }
            }
            data[item[0] as! String] = sumtime.last
            sumtime = [Double](repeating: 0.0, count: dayNumber)
        }
        return data
    }
    
    func getTimeChartData() -> [String: [[[Double]]]] {
        let itemInfo = ManipulateItem().getItemInfo()
        var recordtime = [Double]()
        var sumtime = [[[Double]]]()
        var data = [String: [[[Double]]]]()
        
        for item in itemInfo {
            for i in 0...6 {
                let day = FormatTime().dateFormat().string(from: now - 60*60*24 * Double(6 - i))
                let records = realm.objects(Record.self).filter("date like '\(day)'").filter("name like '\(item[0])'")
                sumtime.append([[Double]]())
                for record in records {
                    let calendar = Calendar.current
                    let sameDayFlag = calendar.compare(record.start, to: record.stop, toGranularity: .day) == .orderedSame
                    if sameDayFlag {//記録が日をまたがない場合の計算
                        //基準時間を設定
                        let hour = calendar.component(.hour, from: record.start)
                        let minute = calendar.component(.minute, from: record.start)
                        let diffData = DateComponents(day: 0, hour: -hour, minute: -minute)
                        let dayStart = calendar.date(byAdding: diffData, to: record.start)!
                        //開始と終了時間を設定
                        let start = calendar.dateComponents([.minute], from: dayStart, to: record.start)
                        let stop = calendar.dateComponents([.minute], from: dayStart, to: record.stop)
                        recordtime = [Double(start.minute!), Double(stop.minute!)]
                        sumtime[i].append(recordtime)
                    }
                    //記録が日をまたいだ場合の計算
                    //これはまだ未実装
                    
//                    var hour = calendar.component(.hour, from: record.stop)
//                    var minute = calendar.component(.minute, from: record.stop)
//                    var beforeDay = 0
//                    var beforeDayCount = 0
//                    var recordEnd = record.stop
//                    while !sameDayFlag {
//                        let diffData = DateComponents(day: -beforeDay, hour: -hour, minute: -minute)
//                        let dayEnd = calendar.date(byAdding: diffData, to: recordEnd)!
//                        hour = 0
//                        minute = 0
//                        if beforeDay == 0 {//初回だけ当日0時に調整
//                            beforeDay += 1
//                        }
//                        sameDayFlag = calendar.compare(record.start, to: dayEnd, toGranularity: .day) == .orderedSame
//                        if sameDayFlag {
//                            let diff = calendar.dateComponents([.second], from: record.start, to: dayEnd + 24 * 60  * 60)
//                            recordtime = Double(diff.second!)/60
//                        } else {
//                            let diff = calendar.dateComponents([.second], from: dayEnd, to: recordEnd)
//                            recordtime = Double(diff.second!)/60
//                        }
//                        if i - beforeDayCount >= 0 {//一週間以上前のデータは計算対象外
//                            sumtime[i - beforeDayCount] += recordtime
//                        }
//                        beforeDayCount += 1
//                        recordEnd = dayEnd
//                    }
                }
            }
            data[item[0] as! String] = sumtime
            sumtime = [[[Double]]]()
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
