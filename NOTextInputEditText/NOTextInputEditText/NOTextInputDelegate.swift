//
//  NOTextInputDelegate.swift
//  NOTextInputEditText
//
//  Created by Deo on 2020/7/7.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import UIKit
import SwiftUI

public class NOTextInputDelegate: NSObject, UITextFieldDelegate {
    private let delegate:UITextFieldDelegate
    private let title:String
    private let text:Binding<String>
    private let isFocusable:Binding<Bool>
    private let onCommit:()->Void
    var label:UILabel
    
    public init(delegate:UITextFieldDelegate,
         title:String,
         text:Binding<String>,
         isFocusable:Binding<Bool>,
         onCommit:@escaping ()->Void){
        self.delegate = delegate
        self.title = title
        self.text = text
        self.isFocusable = isFocusable
        self.onCommit = onCommit
        label = UILabel(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width/2, height: 44))
    }
    @available(iOS 2.0, *)
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.delegate.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.isFocusable.wrappedValue = true
        }
        self.delegate.textFieldDidBeginEditing?(textField)
    }
    
    @available(iOS 2.0, *)
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            self.isFocusable.wrappedValue = false
        }
        return self.delegate.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate.textFieldDidEndEditing?(textField)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.delegate.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    @available(iOS 2.0, *)
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n", let _ = textField.text{
            DispatchQueue.main.async {
                self.isFocusable.wrappedValue = false
                self.onCommit()
            }
            return false
        }
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        DispatchQueue.main.async {
            self.text.wrappedValue = newText
            if textField.isSecureTextEntry {
                self.label.text = self.title
            }else{
                self.label.text = newText
            }
        }
        return self.delegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? false
    }
    
    @available(iOS 13.0, *)
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        self.delegate.textFieldDidChangeSelection?(textField)
    }
    
    @available(iOS 2.0, *)
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.delegate.textFieldShouldClear?(textField) ?? false
    }
    
    @available(iOS 2.0, *)
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate.textFieldShouldReturn?(textField) ?? true
    }
    
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        DispatchQueue.main.async {
            self.isFocusable.wrappedValue = false
            self.onCommit()
        }
    }
}
