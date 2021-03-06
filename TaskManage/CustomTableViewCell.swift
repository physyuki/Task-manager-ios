//
//  CustomTableViewCell.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var startTime: TimeInterval = 0
    var timer = Timer()
    var elapsedtime : TimeInterval = 0.0
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    
    @IBAction func startButton(_ sender: UIButton) {
        startButton.isHidden = true
        stopButton.isHidden = false
        startTime = Date().timeIntervalSince1970
        startTimeLabel.text = FormatTime().getNowTime()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true) //0.1秒おきに関数updateを呼び出す
    }
    
    @objc func update() {
        elapsedtime = Date().timeIntervalSince1970 - startTime
        let sec = Int(elapsedtime)
        elapsedTimeLabel.text = String(format: "%02d:%02d", sec/60, sec%60)
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        stopButton.isHidden = true
        stopTimeLabel.text = FormatTime().getNowTime()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {//終了時刻を数秒見せる
            self.startButton.isHidden = false
            self.startTimeLabel.text = ""
            self.stopTimeLabel.text = ""
            self.elapsedTimeLabel.text = ""
        }
        ManipulateRecord().recordTime(sender: sender, startTime: startTime)
        timer.invalidate() //タイマー処理を止める
    }
    
    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
        stopButton.isHidden = true
    }
    
}
