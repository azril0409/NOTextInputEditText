//
//  ContentView.swift
//  Sample
//
//  Created by Deo on 2020/7/17.
//  Copyright © 2020 NeetOffice. All rights reserved.
//

import SwiftUI
import NOTextInputEditText

struct ContentView: View {
    @State private var account:String = ""
    @State private var accountError:String = ""
    @State private var isAccountFocusable:Bool = false
    @State private var password:String = ""
    @State private var passwordError:String = ""
    @State private var isPasswordFocusable:Bool = false
    
    var body: some View {
        VStack{
            NOTextInputEditText.init(title: "帳號", text: $account, error: $accountError, isFocusable: $isAccountFocusable) {
                
            }
            NOTextInputEditText.init(title: "密碼", text: $password, error: $passwordError, isFocusable: $isPasswordFocusable, isSecureTextEntry: true) {
                if self.password.count < 6 {
                    self.passwordError = "密碼強度不足"
                }else{
                    self.passwordError.removeAll()
                }
            }
        }.padding()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
