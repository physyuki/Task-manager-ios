//
//  recordAddViewController.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2017/12/16.
//  Copyright © 2017年 test company. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController, UITextFieldDelegate {
    
    var red = CGFloat(0.6)
    var green = CGFloat(0.3)
    var blue = CGFloat(0.2)
    var itemName: String = ""
    
    @IBOutlet weak var NameInputField: UITextField!
    @IBOutlet weak var ColorSquare: UIView!
    
    @IBAction func ColorSlider(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            red = CGFloat(sender.value)
            break
        case 1:
            green = CGFloat(sender.value)
            break
        case 2:
            blue = CGFloat(sender.value)
            break
        default:
            break
        }
        ColorSquare.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.9)
    }
    
    
    @IBAction func SaveItem(_ sender: UIButton) {
        ManipulateItem().createNewItem(name: itemName, red: red, green: green, blue: blue)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemName = textField.text as! String //初期値はnil
        NameInputField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameInputField.delegate = self
        ColorSquare.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.9)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
