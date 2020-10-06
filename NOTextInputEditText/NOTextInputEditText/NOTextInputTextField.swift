//
//  NOTextInputTextField.swift
//  NOTextInputEditText
//
//  Created by Deo on 2020/7/7.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NOTextInputTextField:UIViewRepresentable {
    public typealias UIViewType = UITextField
    public typealias Coordinator = NOTextInputDelegate
    private let title:String
    @Binding
    private var text:String
    @Binding
    private var isFocusable:Bool
    private let delegate:UITextFieldDelegate
    private var keyboardType:UIKeyboardType
    private var isSecureTextEntry:Bool
    private var textColor:UIColor
    private var textSize:CGFloat
    private let onCommit:()->Void
    
    public init(title:String = "",
                text:Binding<String>,
                isFocusable:Binding<Bool>,
                delegate:UITextFieldDelegate = DefaultTextFieldDelegate(),
                keyboardType:UIKeyboardType = UIKeyboardType.default,
                isSecureTextEntry:Bool = false,
                textColor:UIColor = UIColor.black,
                textSize:CGFloat = UIFontMetrics.default.scaledFont(for: .preferredFont(forTextStyle: .body)).pointSize,
                onCommit:@escaping ()->Void = {}){
        self.title = title
        self._text = text
        self._isFocusable = isFocusable
        self.delegate = delegate
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.textColor = textColor
        self.textSize = textSize
        self.onCommit = onCommit
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        let delegate = context.coordinator
        textField.delegate = delegate
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("DONE", comment: "DONE"), style: .done, target: delegate, action: #selector(delegate.doneButtonTapped(button:)))
        let label = delegate.label
        label.text = NSLocalizedString(self.title, comment: self.title)
        let title = UIBarButtonItem(customView: label)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([title,space,doneButton], animated: true)
        textField.inputAccessoryView = toolBar
        return textField
    }
    
    public func makeCoordinator() -> NOTextInputDelegate {
        return NOTextInputDelegate(delegate: self.delegate,
                                   title: self.title,
                                   text: self.$text,
                                   isFocusable: self.$isFocusable,
                                   onCommit: onCommit)
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.keyboardType = self.keyboardType
        uiView.isSecureTextEntry = self.isSecureTextEntry
        uiView.font = .systemFont(ofSize: self.textSize)
        uiView.textColor = self.textColor
        DispatchQueue.main.async {
            do{
                _ = try self.isFocusable ? uiView.becomeFirstResponder() : uiView.resignFirstResponder()
            }catch{}
        }
        DispatchQueue.main.async {
            do{
                if uiView.text != self.text {
                    uiView.text = self.text
                }
            }catch{}
        }
    }
}
