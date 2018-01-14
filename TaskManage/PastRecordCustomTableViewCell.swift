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
    
    //日付編集のピッカーはデリゲートを使用して挙動を実装しなくていい
    @objc func tappedDone() {
        print(timePickerView.date)
        //データベースの内容を書き換えて、ラベルの更新（リロードする方が良いか？）
        self.startTime.endEditing(true)
    }
    
    @objc func didSelectRow(sender: UIDatePicker){
        print(sender.date)
        print("hoge")
        //テキストフィールドに反映
        
        //        // フォーマットを生成.
        //        let myDateFormatter: DateFormatter = DateFormatter()
        //        myDateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        //        // 日付をフォーマットに則って取得.
        //        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        //        myTextField.text = mySelectedDate as String
    }
    
}
