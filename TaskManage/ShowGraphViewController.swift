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
    @IBOutlet weak var allSumTime: UILabel!
    var pickerView: UIPickerView = UIPickerView()
    let TYPE: [String] = ["累積グラフ(直近1週間)", "合計グラフ(直近1年)","合計グラフ(直近1週間)", "合計グラフ(本日)", "タイムチャート(直近1週間)"]
    
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
    }
    
    @objc func done() {
        initToRedraw()
        self.graphType.text = TYPE[pickerView.selectedRow(inComponent: 0)]
        selecteChart(selectedRow: pickerView.selectedRow(inComponent: 0))
    }
    
    func initToRedraw() {
        loadView()
        graphType.textAlignment = .center
        allSumTime.textAlignment = .center
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: Coordinate().CGRectMake(0, 0, 0, 35))
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
        switch selectedRow {
        case 0:
            drawChart().drawLineChart(data: ManipulateRecord().getWeekData(), viewController: self)
        case 1:
            let data = ManipulateRecord().getWeekSumData(dayNumber: 365)
            drawChart().drawBarChart(data: data, viewController: self)
            setSumTimeText(data)
        case 2:
            let data = ManipulateRecord().getWeekSumData(dayNumber: 7)
            drawChart().drawBarChart(data: data, viewController: self)
            setSumTimeText(data)
        case 3:
            let data = ManipulateRecord().getWeekSumData(dayNumber: 1)
            drawChart().drawBarChart(data: data, viewController: self)
            setSumTimeText(data)
        case 4:
            drawChart().drawTimeChart(data: ManipulateRecord().getTimeChartData(), viewController: self)
        default:
            break
        }
    }
    
    func setSumTimeText(_ data: [String: Double]) {
        var allSumTime: Int = 0
        for time in data.values {
            allSumTime += Int(time)
        }
        self.allSumTime.text = String(format: "合計%01dh%02dmin", allSumTime / 60, allSumTime % 60)
    }
    
}
