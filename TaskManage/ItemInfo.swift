//
//  ItemInfo.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import RealmSwift

class ItemInfo: Object {
    @objc dynamic var identifier = 0
    @objc dynamic var name = ""
    @objc dynamic var red: CGFloat = CGFloat()
    @objc dynamic var green: CGFloat = CGFloat()
    @objc dynamic var blue: CGFloat = CGFloat()
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}
