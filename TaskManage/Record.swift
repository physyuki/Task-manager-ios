//
//  Record.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import RealmSwift

class Record: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var start: Date = Date()
    @objc dynamic var stop: Date = Date()
    @objc dynamic var date: String = ""
}
