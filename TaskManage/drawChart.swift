//
//  drawChart.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class drawChart {
    
    func drawLineChart(data: [String: [Double]], viewController: UIViewController) {
        let rect = CGRect(x:20, y: 30, width: viewController.view.frame.width * 0.9, height: viewController.view.frame.height * 0.8)
        let chartView = LineChartView(frame: rect)
        var entries = [[ChartDataEntry]]()
        var dataSets = [LineChartDataSet]()
        var i = 0
        for (key, value) in data {
            //空の配列を追加する
            entries.append([ChartDataEntry]())
            for (j, d) in value.enumerated() {
                entries[i].append(ChartDataEntry(x: Double(j), y: d ))
            }
            let dataSet = LineChartDataSet(values: entries[i], label: key)
            i += 1
            
            let itemInfo = ManipulateItem().getItemColer(forKey: key)
            let red: CGFloat = itemInfo.red
            let green: CGFloat = itemInfo.green
            let blue: CGFloat = itemInfo.blue
            //データの設定
            dataSet.drawValuesEnabled = false
            dataSet.lineWidth = 2
            dataSet.circleRadius = 4
            dataSet.drawCircleHoleEnabled = false
            dataSet.colors = [UIColor(red: red, green: green, blue: blue, alpha: 0.9)]
            dataSet.circleColors = [UIColor(red: red, green:green, blue: blue, alpha: 0.9)]
            dataSets.append(dataSet)
        }
        //x軸の設定
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.valueFormatter = lineChartxAxisFormatter()
        //y軸の設定
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.leftAxis.valueFormatter = lineChartyAxisFormatter()
        //その他設定
        chartView.legend.font = UIFont(name: "HiraginoSans-W3", size: 10)!
        chartView.chartDescription?.text = ""
        
        //chartView.data = LineChartData(dataSet: dataSet)　→ LineChartData(dataSets: dataSets as! [IChartDataSet])
        chartView.data = LineChartData(dataSets: dataSets as [IChartDataSet])
        viewController.view.addSubview(chartView)
    }
    
    //x軸のラベルの値を設定
    public class lineChartxAxisFormatter: NSObject, IAxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return ManipulateRecord().getWeekDateInfo()[Int(value)]
        }
    }
    
    //y軸のラベルの値を設定
    public class lineChartyAxisFormatter: NSObject, IAxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return String(Double(value)) + "h"
        }
    }
    
}
