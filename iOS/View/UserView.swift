//
//  UserView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: Store

    @State  var email: String = ""
    @State  var password: String = ""
    private var settings: AppState.Settings { store.appState.settings }
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
                .onTapGesture{
                    UIApplication.shared.endEditing()
                }
            VStack(spacing: 20.0) {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    Text("用户")
                    Spacer()
                    Button(action: {
                    }) {
                        NavigationLink(destination: SettingsView()) {
                            NEUButtonView(systemName: "gear", size: .medium)
                        }
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                if store.appState.settings.loginUser == nil {
                    TextField("email", text: $email)
                        .textFieldStyle(NEUTextFieldStyle(label: NEUButtonView(systemName: "envelope", size: .medium)))
                        .autocapitalization(.none)
                    SecureField("password", text: $password)
                        .textFieldStyle(NEUTextFieldStyle(label: NEUButtonView(systemName: "key", size: .medium)))
                        .autocapitalization(.none)
                    Button(action: {
                        self.store.dispatch(.login(email: self.email, password: self.password))
                    }) {
                        Text("登录")
                            .padding()
                    }
                    .buttonStyle(NEUButtonStyle(shape: Capsule()))
                    if store.appState.settings.loginRequesting {
                        Text("正在登录。。。。")
                    }
                    if (store.appState.settings.loginError != nil) {
                        Text("\(store.appState.settings.loginError!.localizedDescription)")
                    }
                }else {
                    NEUImageView(url: settings.loginUser!.profile.avatarUrl, size: .medium, innerShape: RoundedRectangle(cornerRadius: 25.0, style: .continuous), outerShape: RoundedRectangle(cornerRadius: 30, style: .continuous))
                    Text("uid: \(String(settings.loginUser!.uid))")
                    Text("csrf: \(settings.loginUser!.csrf)")
                    Button(action: {
                        Store.shared.dispatch(.logout)
                    }) {
                        Text("退出登录")
                            .padding()
                    }
                    .buttonStyle(NEUButtonStyle(shape: Capsule()))
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(Store.shared)
            .environment(\.colorScheme, .light)
    }
}
#endif
