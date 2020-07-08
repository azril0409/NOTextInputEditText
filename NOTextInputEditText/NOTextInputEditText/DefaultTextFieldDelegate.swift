//
//  DefaultTextFieldDelegate.swift
//  NOTextInputEditText
//
//  Created by Deo on 2020/7/8.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import UIKit

class DefaultTextFieldDelegate:NSObject,UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
