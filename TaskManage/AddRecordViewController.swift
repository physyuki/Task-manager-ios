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
        if itemName.isEmpty {
            let alertController = UIAlertController(title: "",message: "項目名を入力してください", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(okButton)
            present(alertController, animated: true, completion: nil)
        } else {
            ManipulateItem().createNewItem(name: itemName, red: red, green: green, blue: blue)
            loadView()
            viewDidLoad()
        }
    }
    
    @IBAction func watchItemName(_ sender: UITextField) {
        itemName = NameInputField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NameInputField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        red = CGFloat(0.6)
        green = CGFloat(0.3)
        blue = CGFloat(0.2)
        itemName = ""
        NameInputField.delegate = self
        ColorSquare.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.9)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
