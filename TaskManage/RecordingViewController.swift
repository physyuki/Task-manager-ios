//
//  RecordingViewController.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit

class RecordingViewController: UITableViewController {
    var itemInfo = [[Any]]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemInfo.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // データの順番を整える
        var ds = itemInfo
        let data = itemInfo[sourceIndexPath.row]
        ds.remove(at: sourceIndexPath.row)
        ds.insert(data, at: destinationIndexPath.row)
        itemInfo = ds
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "TableView"
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemInfo = ManipulateItem().getItemInfo()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
