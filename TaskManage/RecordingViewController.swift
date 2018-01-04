//
//  RecordingViewController.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit

class RecordingViewController: UITableViewController {
    let userDefaults = UserDefaults.standard
    var itemInfo = [[Any]]()
    @IBOutlet weak var naviItem: UINavigationItem!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return itemInfo.count}
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {return true}
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {return true}
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){// データの順番を整える
        let data = itemInfo[sourceIndexPath.row]
        itemInfo.remove(at: sourceIndexPath.row)
        itemInfo.insert(data, at: destinationIndexPath.row)
        userDefaults.set(itemInfo, forKey: "itemInfo")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "注意", message: "項目を削除するとこれまでの記録も全て消えます!", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            let name = self.itemInfo[indexPath.row][0] as! String
            self.itemInfo.remove(at: indexPath.row)// 先にデータを更新する
            ManipulateRecord().deleteRecord(name)
            ManipulateItem().deleteItemInfo(name)
            self.userDefaults.set(self.itemInfo, forKey: "itemInfo")
            self.tableView.deleteRows(at: [indexPath], with: .fade)// それからテーブルの更新、こうしないと落ちる
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        present(alertController,animated: true,completion: nil)
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let red: CGFloat = itemInfo[indexPath.row][2] as! CGFloat
        let green: CGFloat = itemInfo[indexPath.row][3] as! CGFloat
        let blue: CGFloat = itemInfo[indexPath.row][4] as! CGFloat
        cell.textLabel?.textColor = UIColor(red: red, green: green, blue: blue, alpha: 0.9)
        cell.textLabel?.text = itemInfo[indexPath.row][0] as? String
        cell.startButton.setTitle("start", for: .normal)
        cell.stopButton.tag = itemInfo[indexPath.row][1] as! Int
        cell.stopButton.setTitle("stop", for: .normal)
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.isEditing = editing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        naviItem.title = "記録"
        naviItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let recentItemInfo = ManipulateItem().getItemInfo()
        if (userDefaults.array(forKey: "itemInfo") == nil && recentItemInfo.count != 0) {
            itemInfo = recentItemInfo
            userDefaults.set(itemInfo, forKey: "itemInfo")
        } else if (recentItemInfo.count != 0) {
            if (recentItemInfo.count != userDefaults.array(forKey: "itemInfo")?.count) {
                itemInfo = recentItemInfo
                userDefaults.set(itemInfo, forKey: "itemInfo")
            } else {
                itemInfo = userDefaults.array(forKey: "itemInfo") as! [[Any]]
            }
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
