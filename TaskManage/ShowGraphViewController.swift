//
//  SecondViewController.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit

class ShowGraphViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var graphType: UITextField!
    var pickerView: UIPickerView = UIPickerView()
    let TYPE: [String] = ["累積グラフ(直近1週間)", "合計グラフ(直近1週間)", "タイムチャート(直近1週間)"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TYPE.count
    }
    
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return TYPE[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.graphType.text = TYPE[row]
        //userDefaults.set(TYPE[row], forKey: "graphType")
    }
    
    @objc func done() {
        initToRedraw()
        self.graphType.text = TYPE[pickerView.selectedRow(inComponent: 0)]
        selecteChart(selectedRow: pickerView.selectedRow(inComponent: 0))
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func initToRedraw() {
        loadView()
        graphType.textAlignment = .center
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        toolbar.setItems([doneItem], animated: true)
        self.graphType.inputView = pickerView
        self.graphType.inputAccessoryView = toolbar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        initToRedraw()
        //ピッカーとテキストフィールドをデフォルト値に初期化
        pickerView.selectRow(0, inComponent: 0, animated: true)
        self.graphType.text = TYPE[0]
        
        selecteChart(selectedRow: pickerView.selectedRow(inComponent: 0))
    }
    
    func selecteChart(selectedRow: Int) {
        //switch pickerView.selectedRow(inComponent: 0) {
        switch selectedRow {
        case 0:
            drawChart().drawLineChart(data: ManipulateRecord().getWeekData(), viewController: self)
        case 1:
            drawChart().drawBarChart(data: ManipulateRecord().getWeekSumData(), viewController: self)
        case 2:
            drawChart().drawTimeChart(data: ManipulateRecord().getTimeChartData(), viewController: self)
        default:
            break
        }
    }
    
}
