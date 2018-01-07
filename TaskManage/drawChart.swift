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
    let userDefaults = UserDefaults.standard
    
    func drawLineChart(data: [String: [Double]], viewController: UIViewController) {
        let rect = CGRect(x:35, y: 50, width: viewController.view.frame.width * 0.85, height: viewController.view.frame.height * 0.8)
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
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 9)
        chartView.xAxis.axisLineColor = UIColor.black
        chartView.xAxis.axisLineWidth = CGFloat(1.0)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.valueFormatter = lineChartxAxisFormatter()
        //y軸の設定
        chartView.rightAxis.axisLineColor = UIColor.black
        chartView.rightAxis.axisLineWidth = CGFloat(1.0)
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.drawBottomYLabelEntryEnabled = false
        chartView.rightAxis.gridColor = UIColor.gray.withAlphaComponent(0.3)
        chartView.rightAxis.valueFormatter = lineChartyAxisFormatter()

        chartView.leftAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.drawAxisLineEnabled = false
        //その他設定
        chartView.legend.orientation = Legend.Orientation.vertical
        chartView.legend.drawInside = true
        chartView.legend.horizontalAlignment = .left
        chartView.legend.verticalAlignment = .top
        chartView.legend.font = UIFont(name: "HiraginoSans-W3", size: 10)!
        chartView.chartDescription?.text = ""
        
        //chartView.data = LineChartData(dataSet: dataSet)　→ LineChartData(dataSets: dataSets as! [IChartDataSet])
        chartView.data = LineChartData(dataSets: dataSets as [IChartDataSet])
        viewController.view.addSubview(chartView)
    }
    
    func drawBarChart(data: [String: Double], viewController: UIViewController) {
        let rect = CGRect(x:35, y: 50, width: viewController.view.frame.width * 0.85, height: viewController.view.frame.height * 0.8)
        let chartView = BarChartView(frame: rect)
        var entries = [[BarChartDataEntry]]()
        var dataSets = [BarChartDataSet]()
        let barChartLabel = [String](data.keys)
        userDefaults.set(barChartLabel, forKey: "barChartLabel")
        
        var i = 0
        for (key, value) in data {
            //空の配列を追加する
            entries.append([BarChartDataEntry]())
            for j in 0...(data.count - 1) {
                if i == j {
                    entries[i].append(BarChartDataEntry(x: Double(j), y: value ))
                } else {
                    entries[i].append(BarChartDataEntry(x: Double(j), y: 0 ))
                }
            }
            let dataSet = BarChartDataSet(values: entries[i], label: key)
            i += 1
            
            let itemInfo = ManipulateItem().getItemColer(forKey: key)
            let red: CGFloat = itemInfo.red
            let green: CGFloat = itemInfo.green
            let blue: CGFloat = itemInfo.blue
            //データの設定
            dataSet.drawValuesEnabled = false
            dataSet.colors = [UIColor(red: red, green: green, blue: blue, alpha: 0.9)]
            dataSets.append(dataSet)
        }
        
        //x軸の設定
        chartView.xAxis.axisLineColor = UIColor.black
        chartView.xAxis.axisLineWidth = CGFloat(1.0)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.labelPosition = .bottom
        //chartView.xAxis.valueFormatter = barChartxAxisFormatter()
        //y軸の設定
        chartView.rightAxis.axisLineColor = UIColor.black
        chartView.rightAxis.axisLineWidth = CGFloat(1.0)
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.drawBottomYLabelEntryEnabled = false
        chartView.rightAxis.gridColor = UIColor.gray.withAlphaComponent(0.3)
        chartView.rightAxis.valueFormatter = lineChartyAxisFormatter()
        
        chartView.leftAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.drawAxisLineEnabled = false
        //その他設定
        chartView.legend.orientation = Legend.Orientation.vertical
        chartView.legend.drawInside = true
        chartView.legend.horizontalAlignment = .left
        chartView.legend.verticalAlignment = .top
        chartView.legend.font = UIFont(name: "HiraginoSans-W3", size: 10)!
        chartView.chartDescription?.text = ""
        
        chartView.data = BarChartData(dataSets: dataSets as [IChartDataSet])
        viewController.view.addSubview(chartView)
    }
    
    //x軸のラベルの値を設定
    public class lineChartxAxisFormatter: NSObject, IAxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return ManipulateRecord().getWeekDateInfo()[Int(value)]
        }
    }
    
    //x軸のラベルの値を設定
    //    public class barChartxAxisFormatter: NSObject, IAxisValueFormatter{
    //        let userDefaults = UserDefaults.standard
    //        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    //            // 0 -> Jan, 1 -> Feb...
    //            //print(Int(value))
    //            print((userDefaults.array(forKey: "barChartLabel") as! [String])[Int(value)])
    //            return (userDefaults.array(forKey: "barChartLabel") as! [String])[Int(value)]
    //        }
    //    }
    
    //y軸のラベルの値を設定
    public class lineChartyAxisFormatter: NSObject, IAxisValueFormatter{
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let hour: Int = Int(value) / 60
            let min: Int = Int(value.truncatingRemainder(dividingBy: 60))
            if Int(min) == 0 {
                return String(hour) + "h"
            } else {
                return String(hour) + "h" + String(min) + "min"
            }
        }
    }
    
}
