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
    var timePickerView: UIDatePicker = UIDatePicker()
    var preUpdate: Date = Date()
    
    //日付編集のピッカーはデリゲートを使用して挙動を実装しなくていい
    @objc func tappedDone() {
        //データベースの内容を書き換えて、ラベルの更新
        ManipulateRecord().updateRecord(key: startTime.tag, preUpdate, update: timePickerView.date)
        //ピッカーの初期値も変更したいここでやるべきではないが
        let f = FormatTime().logFormat()
        let update = f.string(from: timePickerView.date)
        startTime.text = String(describing: update)
        self.startTime.endEditing(true)
    }
    
    @objc func didSelectRow(sender: UIDatePicker){
        //日付変更中の処理
    }
    
}
