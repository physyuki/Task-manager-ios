//
//  CustomTextField.swift
//  TaskManage
//
//  Created by 藤田幸秀 on 2018/01/07.
//  Copyright © 2018年 test company. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    // 入力カーソル非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    // 範囲選択カーソル非表示
    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }
    
    // コピー・ペースト・選択等のメニュー非表示
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
}
