//
//  ManipulateItem.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import RealmSwift

class ManipulateItem {
    let realm = try! Realm()
    
    var maxId: Int {
        return try! realm.objects(ItemInfo.self).sorted(byKeyPath: "identifier").last?.identifier ?? 0
    }
    
    func createNewItem(name: String, red: CGFloat, green: CGFloat, blue: CGFloat) {
        let iteminfo = ItemInfo()
        iteminfo.identifier = maxId + 1
        iteminfo.name = name
        iteminfo.red = red
        iteminfo.green = green
        iteminfo.blue = blue
        
        try! realm.write{ realm.add(iteminfo) }
    }
    
    func deleteItemInfo(_ name: String) {
        let names = realm.objects(ItemInfo.self).filter("name like '\(name)'")
        names.forEach { name in try! realm.write() {realm.delete(name)}}
    }
    
    func getItemInfo() -> [[Any]] {
        print(Realm.Configuration.defaultConfiguration.fileURL!) //DBパス確認用
        var itemInfo = [[Any]]()
        let itemInfos = realm.objects(ItemInfo.self)
        for iteminfo in itemInfos {
            itemInfo.append([iteminfo.name, iteminfo.identifier, iteminfo.red, iteminfo.green, iteminfo.blue])
        }
        return itemInfo
    }
    
    func getAllitemName() -> [String] {
        var nameList = [String]()
        let results: Results<ItemInfo>? = realm.objects(ItemInfo.self)
        if results?.count != 0 {
            for result in results! {
                nameList.append(result.name)
            }
        } else {
            nameList.append("")
        }
        return nameList
    }
    
    func getItemColer(forKey: String) -> ItemInfo {
        return realm.objects(ItemInfo.self).filter("name like '\(forKey)'").first!
    }
}
