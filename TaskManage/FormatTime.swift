//
//  FormatTime.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit

class FormatTime {
    
    func getNowTime() -> String {
        let f = DateFormatter()
        let now = Date()
        f.dateStyle = .none
        f.timeStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: now)
    }
    
    func dateFormat() -> DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        return f
    }
    
    func logFormat() -> DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        return f
    }
    
    func getDayFormat() -> DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }
    
    func getMonthFormat() -> DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "MMM"
        f.locale = Locale(identifier: "ja_JP")
        return f
    }
    
    func getYearFormat() -> DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "y"
        f.locale = Locale(identifier: "ja_JP")
        return f
    }
    
}
