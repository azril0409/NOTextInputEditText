//
//  NOTextInputTextField.swift
//  NOTextInputEditText
//
//  Created by Deo on 2020/7/7.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

struct NOTextInputTextField:UIViewRepresentable {
    typealias UIViewType = UITextField
    typealias Coordinator = NOTextInputDelegate
    var title:String = ""
    @Binding
    var text:String
    @Binding
    var isFocusable:Bool
    var delegate:UITextFieldDelegate = DefaultTextFieldDelegate()
    var keyboardType:UIKeyboardType = UIKeyboardType.default
    var isSecureTextEntry:Bool = false
    var textColor:Color = Color.black
    var textSize:CGFloat = UIFontMetrics.default.scaledFont(for: .preferredFont(forTextStyle: .body)).pointSize
    var onCommit:()->Void = {}
    
    func makeUIView(context: Context) -> UITextField {
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
    
    func makeCoordinator() -> NOTextInputDelegate {
        return NOTextInputDelegate(delegate: self.delegate,
                                   title: self.title,
                                   text: self.$text,
                                   isFocusable: self.$isFocusable,
                                   onCommit: onCommit)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.keyboardType = self.keyboardType
        uiView.isSecureTextEntry = self.isSecureTextEntry
        uiView.font = .systemFont(ofSize: self.textSize)
        uiView.textColor = self.toUIColor(color: self.textColor)
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

    private func toUIColor(color:Color) -> UIColor {
        let scanner = Scanner(string: color.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
