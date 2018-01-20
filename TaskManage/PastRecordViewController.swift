//
//  PastRecordViewController.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2018/01/04.
//  Copyright © 2018年 test company. All rights reserved.
//

import UIKit

class PastRecordViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var itemNameField: UITextField!
    var pickerView: UIPickerView = UIPickerView()
    var nameList = [[Any]]()
    var recordList = [[Date]]()

    //項目選択のピッカーはデリゲートを使用して挙動を実装
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return nameList.count}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return nameList[row][0] as? String}
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.itemNameField.text = nameList[row][0] as? String
        self.itemNameField.tag = nameList[row][1] as! Int
        recordList = ManipulateRecord().getRecord(name: itemNameField.text!)
        self.tableView.reloadData()
    }
    
    @objc func done() {self.itemNameField.endEditing(true)}
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return recordList.count}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! PastRecordCustomTableViewCell
        //日付編集のピッカーを実装
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: cell, action: #selector(cell.tappedDone))
        toolbar.setItems([doneItem], animated: true)
        cell.timePickerView.addTarget(cell, action: #selector(cell.didSelectRow), for: .valueChanged)
        cell.startTime.inputView = cell.timePickerView
        cell.startTime.inputAccessoryView = toolbar
        //日付編集のピッカーの初期設定
        cell.timePickerView.locale = Locale(identifier: "ja_JP")
        cell.timePickerView.date = recordList[indexPath.row][0]
        //ピッカーに表示するログのフォーマットを設定
        let f = FormatTime().logFormat()
        let start = f.string(from: recordList[indexPath.row][0])
        let stop = f.string(from: recordList[indexPath.row][1])
        cell.preUpdate = recordList[indexPath.row][0]
        cell.startTime.text = String(describing: start)
        cell.startTime.tag = self.itemNameField.tag
        cell.stopTime.text = String(describing: stop)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameField.textAlignment = .center
        //項目選択のピッカーを実装
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        toolbar.setItems([doneItem], animated: true)
        self.itemNameField.inputView = pickerView
        self.itemNameField.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameList = ManipulateItem().getItemInfo()
        self.itemNameField.text = nameList[0][0] as? String
        self.itemNameField.tag = nameList[0][1] as! Int //プライマリキーをタグに設定
        recordList = ManipulateRecord().getRecord(name: itemNameField.text!)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
