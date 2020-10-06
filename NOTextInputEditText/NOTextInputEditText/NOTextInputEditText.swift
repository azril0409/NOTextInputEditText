//
//  NOTextInputEditText.swift
//  NOTextInputEditText
//
//  Created by Deo on 2020/7/8.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI

public struct NOTextInputEditText:View{
    private let title:String
    @Binding
    private var text:String
    @Binding
    private var error:String
    @Binding
    private var isFocusable:Bool
    private let delegate:UITextFieldDelegate
    private let keyboardType:UIKeyboardType
    private let isSecureTextEntry:Bool
    private let primaryColor:UIColor
    private let titleColor:UIColor
    private let textColor:UIColor
    private let errorColor:UIColor
    private let textSize:CGFloat
    private let onCommit:()->Void
    
    public init(title:String,
                text:Binding<String>,
                error:Binding<String>,
                isFocusable:Binding<Bool>,
                delegate:UITextFieldDelegate = DefaultTextFieldDelegate(),
                keyboardType:UIKeyboardType = UIKeyboardType.default,
                isSecureTextEntry:Bool = false,
                primaryColor:UIColor = UIColor.red,
                titleColor:UIColor = UIColor.black,
                textColor:UIColor = UIColor.black,
                errorColor:UIColor = UIColor.red,
                textSize:CGFloat = UIFontMetrics.default.scaledFont(for: .preferredFont(forTextStyle: .body)).pointSize,
                onCommit:@escaping ()->Void = {}){
        self.title = title
        self._text = text
        self._error = error
        self._isFocusable = isFocusable
        self.delegate = delegate
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.primaryColor = primaryColor
        self.titleColor = titleColor
        self.textColor = textColor
        self.errorColor = errorColor
        self.textSize = textSize
        self.onCommit = onCommit
    }
    
    public var body: some View{
        VStack{
            HStack {
                Text(NSLocalizedString(self.title, comment: self.title)).font(.system(size: self.textSize)).foregroundColor(self.isFocusable ? Color(self.primaryColor):Color(self.titleColor)).lineLimit(1).minimumScaleFactor(0.1)
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
            Divider().background(self.isFocusable ? Color(self.primaryColor):Color(self.textColor))
            HStack{
                if !self.error.isEmpty{
                    Text(NSLocalizedString(self.error, comment: self.error)).font(.system(size: self.textSize)).foregroundColor(Color(self.errorColor)).lineLimit(1).minimumScaleFactor(0.1)
                }
                Spacer()
            }.frame(height: self.textSize)
        }
    }
}

#if DEBUG
struct NOTextInputEditText_Previews: PreviewProvider {
    static var previews: some View {
        NOTextInputEditText(title: "帳號",
                            text: Binding<String>(get: {""}, set: {_ in}),
                            error: Binding<String>(get: {""}, set: {_ in}),
                            isFocusable: Binding<Bool>(get: {false}, set: {_ in})) {
        }
    }
}
#endif
