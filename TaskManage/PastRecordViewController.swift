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
    var nameList = [String]()
    var recordList = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return nameList.count}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return nameList[row]}
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.itemNameField.text = nameList[row]
        recordList = ManipulateRecord().getRecord(name: itemNameField.text!)
        self.tableView.reloadData()
    }
    
    @objc func done() {self.itemNameField.endEditing(true)}
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return recordList.count}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = recordList[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameField.textAlignment = .center
        
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
        nameList = ManipulateItem().getAllitemName()
        self.itemNameField.text = nameList[0]
        recordList = ManipulateRecord().getRecord(name: itemNameField.text!)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}