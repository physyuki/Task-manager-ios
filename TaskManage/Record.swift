//
//  Record.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import RealmSwift

class Record: Object {
    @objc dynamic var name = ""
    @objc dynamic var start: TimeInterval = 0
    @objc dynamic var stop: TimeInterval = 0
    @objc dynamic var date: String = ""
}
