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
    @IBOutlet weak var logNaviItem: UINavigationItem!
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return recordList.count}
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {return true}
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "注意", message: "一度削除すると元に戻せません", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
            (action: UIAlertAction) in
            let name = self.itemNameField.text
            let start = self.recordList[indexPath.row][0]
            self.recordList.remove(at: indexPath.row)//先にデータを更新する
            ManipulateRecord().deleteRecord(name: name!, startTime: start)
            self.tableView.deleteRows(at: [indexPath], with: .fade)// それからテーブルの更新、こうしないと落ちる
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        present(alertController,animated: true,completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! PastRecordCustomTableViewCell
        //日付編集のピッカーを実装
        cell.setStartPicker(initDisplay: recordList[indexPath.row][0])
        cell.setStopPicker(initDisplay: recordList[indexPath.row][1])
        //ピッカーに表示するログのフォーマットを設定
        let f = FormatTime().logFormat()
        let start = f.string(from: recordList[indexPath.row][0])
        cell.startTime.text = String(describing: start)
        cell.startTime.tag = self.itemNameField.tag
        
        let stop = f.string(from: recordList[indexPath.row][1])
        cell.stopTime.text = String(describing: stop)
        cell.stopTime.tag = self.itemNameField.tag
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameField.textAlignment = .center
        logNaviItem.title = "履歴"
        logNaviItem.rightBarButtonItem = editButtonItem
        //項目選択のピッカーを実装
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: Coordinate().CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        toolbar.setItems([doneItem], animated: true)
        self.itemNameField.inputView = pickerView
        self.itemNameField.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameList = ManipulateItem().getItemInfo()
        self.itemNameField.text = nameList[0][0] as? String
        self.itemNameField.tag = nameList[0][1] as! Int //プライマリキーをタグに設定
        pickerView.selectRow(0, inComponent: 0, animated: true)
        recordList = ManipulateRecord().getRecord(name: itemNameField.text!)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
