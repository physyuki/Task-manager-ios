//
//  SecondViewController.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit

class ShowGraphViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        drawChart(self).drawLineChart(data: ManipulateRecord().getWeekData())
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

