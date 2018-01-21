//
//  PastRecordCustomTableView.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2018/01/14.
//  Copyright © 2018年 test company. All rights reserved.
//

import UIKit

class PastRecordCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var stopTime: UITextField!
    var startTimePickerView: UIDatePicker = UIDatePicker()
    var stopTimePickerView: UIDatePicker = UIDatePicker()
    var preUpdateStart: Date = Date()
    var preUpdateStop: Date = Date()
    //日付編集のピッカーはデリゲートを使用して挙動を実装しなくていい
    
    func setStartPicker(initDisplay: Date) {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.tappedDone))
        doneItem.tag = 0
        toolbar.setItems([doneItem], animated: true)
        startTimePickerView.addTarget(self, action: #selector(self.didSelectRow), for: .valueChanged)
        startTime.inputView = startTimePickerView
        startTime.inputAccessoryView = toolbar
        startTimePickerView.locale = Locale(identifier: "ja_JP")
        startTimePickerView.date = initDisplay
        preUpdateStart = initDisplay
    }
    
    func setStopPicker(initDisplay: Date) {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.tappedDone))
        doneItem.tag = 1
        toolbar.setItems([doneItem], animated: true)
        stopTimePickerView.addTarget(self, action: #selector(self.didSelectRow), for: .valueChanged)
        stopTime.inputView = stopTimePickerView
        stopTime.inputAccessoryView = toolbar
        stopTimePickerView.locale = Locale(identifier: "ja_JP")
        stopTimePickerView.date = initDisplay
        preUpdateStop = initDisplay
    }
    
    @objc func tappedDone(sender: UIDatePicker) {
        print(sender.tag)
        let f = FormatTime().logFormat()
        //データベースの内容を書き換えて、ラベルの更新
        switch sender.tag {
        case 0:
            ManipulateRecord().updateRecord(key: startTime.tag, preUpdateStart, update: startTimePickerView.date, witchTime: "start")
            let update = f.string(from: startTimePickerView.date)
            startTime.text = String(describing: update)
            preUpdateStart = startTimePickerView.date
            self.startTime.endEditing(true)
        case 1:
            ManipulateRecord().updateRecord(key: stopTime.tag, preUpdateStop, update: stopTimePickerView.date, witchTime: "stop")
            let update = f.string(from: stopTimePickerView.date)
            stopTime.text = String(describing: update)
            preUpdateStop = stopTimePickerView.date
            self.stopTime.endEditing(true)
        default:
            break
        }
        
    }
    
    @objc func didSelectRow(sender: UIDatePicker){
        //日付変更中の処理
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}
