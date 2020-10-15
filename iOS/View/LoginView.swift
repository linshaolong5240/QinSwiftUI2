//
//  LoginView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/15.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var store: Store
    private var settings: AppState.Settings { store.appState.settings }

    @State  private var email: String = ""
    @State  private var password: String = ""
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 20.0) {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                }
                .overlay(
                    NEUNavigationBarTitleView("登录")
                )
                TextField("email", text: $email)
                    .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "envelope", size: .medium)))
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("password", text: $password)
                    .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "key", size: .medium)))
                    .autocapitalization(.none)
                    .keyboardType(.asciiCapable)
                Button(action: {
                    self.store.dispatch(.login(email: self.email, password: self.password))
                }) {
                    Text("登录")
                        .padding()
                }
                .buttonStyle(NEUButtonStyle(shape: Capsule()))
                if store.appState.settings.loginRequesting {
                    Text("正在登录...")
                }
                if (store.appState.settings.loginError != nil) {
                    Text("\(store.appState.settings.loginError!.localizedDescription)")
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
