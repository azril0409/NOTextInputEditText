//
//  NOTextInputEditText.swift
//  NOTextInputEditText
//
//  Created by Deo on 2020/7/7.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

struct NOTextInputEditText:View{
    let title:String
    @Binding
    var text:String
    @Binding
    var error:String
    @Binding
    var isFocusable:Bool
    var delegate:UITextFieldDelegate = DefaultTextFieldDelegate()
    var keyboardType:UIKeyboardType = UIKeyboardType.default
    var isSecureTextEntry:Bool = false
    var titleColor = Color.black
    var textColor = Color.black
    var hintColor:Color = Color.init(red: 214.0/255, green: 214.0/255, blue: 214.0/255)
    var errorColor:Color = Color.red
    let textSize = UIFontMetrics.default.scaledFont(for: .preferredFont(forTextStyle: .body)).pointSize
    var onCommit:()->Void = {}
    
    var body: some View{
        VStack{
            HStack {
                Text(NSLocalizedString(self.title, comment: self.title)).font(.system(size: self.textSize)).foregroundColor(self.titleColor).lineLimit(1).minimumScaleFactor(0.1)
                Spacer()
                
            }.frame(height: self.textSize)
                .offset(y:(self.isFocusable || !self.text.isEmpty) ? 0 : self.textSize*2-4)
                .animation(.spring())
            NOTextInputTextField(title: self.title,
                                 text: self.$text,
                                 isFocusable: self.$isFocusable,
                                 delegate: self.delegate,
                                 keyboardType: self.keyboardType,
                                 isSecureTextEntry: self.isSecureTextEntry,
                                 textColor: self.textColor,
                                 textSize: self.textSize,
                                 onCommit: self.onCommit).frame(height: self.textSize).frame(maxWidth: UIScreen.main.bounds.width)
            Divider()
            HStack{
                if !self.error.isEmpty{
                    Image(systemName: "multiply.circle").resizable().scaledToFit().foregroundColor(errorColor)
                    Text(NSLocalizedString(self.error, comment: self.error)).font(.system(size: self.textSize)).foregroundColor(self.errorColor).lineLimit(1).minimumScaleFactor(0.1)
                }
                Spacer()
            }.frame(height: self.textSize)
        }
    }
}
