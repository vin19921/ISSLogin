//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import Combine
import ISSCommonUI
import ISSTheme
import SwiftUI
import UIKit

public struct LoginView: View {

    @ObservedObject private var presenter: LoginPresenter

    @State private var isLoading = false

    @State private var phoneText = ""
    @State private var passwordText = ""

    @State private var phoneErrorState = false
    @State private var passwordErrorState = false

    @State private var isLoggedIn = false

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)
                ScrollView {
                    VStack(spacing: 16) {
                        LoginImageAssets.issLogo.image
                            .resizable()
                            .frame(width: 128, height: 128)
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 50)
                        Spacer()
                        ISSTextFieldSUI(inputString: $phoneText,
                                        isErrorState: $phoneErrorState,
                                        isDisabled: .constant(false),
                                        viewData: ISSTextFieldSUI.ViewData(placeholderText: "Mobile No.",
                                                                           keyboardType: .numberPad,
                                                                           errorBorderColor: Theme.current.issBlack.color,
                                                                           leadingImageIcon: Image(systemName: "iphone"),
                                                                           prefix: "+60")
                        )
                        .onReceive(Just(phoneText)) { newValue in
                            let regex = try! NSRegularExpression(pattern: RegExConstants.minNineDigitRegEx)
                            let range = NSRange(location: 0, length: newValue.utf16.count)

                            if regex.firstMatch(in: newValue, options: [], range: range) != nil {
                                phoneErrorState = false
                            } else {
                                phoneErrorState = true
                            }
                        }

                        ISSSecureFieldSUI(inputString: $passwordText,
                                          isErrorState: $passwordErrorState,
                                          viewData: ISSSecureFieldSUI.ViewData(placeholderText: "Password",
                                                                               errorBorderColor: Theme.current.issBlack.color,
                                                                               leadingImageIcon: Image(systemName: "lock"))
                        )
                        .onReceive(Just(passwordText)) { newValue in
                            if newValue.count > 7 {
                                passwordErrorState = false
                            } else {
                                passwordErrorState = true
                            }
                        }

                        Button(action: {
                            isLoading.toggle()
                            presenter.fetchLogin(request: Login.Model.Request(mobileNo: "60\(phoneText)",
                                                                              password: passwordText),
                                                 completionHandler: {
                                                    isLoading.toggle()
                                                 })
                        }) {
                            Text("Login")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 8)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(!validated() ? Theme.current.disabledGray1.color : Theme.current.issWhite.color)
                                .background(!validated() ? Theme.current.grayDisabled.color : Theme.current.issBlack.color)
                                .cornerRadius(12)
                        }
                        .disabled(!validated())

                        FacebookLoginButtonView(isLoggedIn: $isLoggedIn, isLoading: $isLoading, action: { fullName, email in
                            isLoading.toggle()
                            presenter.routeToRegister(fullName: fullName, email: email)
                        })
                        GoogleLoginButtonView(isLoggedIn: $isLoggedIn, isLoading: $isLoading, action: { fullName, email in
                            isLoading.toggle()
                            presenter.routeToRegister(fullName: fullName, email: email)
                        })
                        AppleLoginButtonView(isLoggedIn: $isLoggedIn, isLoading: $isLoading, action: { fullName, email in
                            isLoading.toggle()
                            presenter.routeToRegister(fullName: fullName, email: email)
                        })
                        
                        Text("Forget Password")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyThreeRegular.lineHeight,
                                                verticalPadding: 0)
                            .onTapGesture {
                                presenter.routeToResetPassword()
                            }
                        
                        Text("Register")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyThreeRegular.lineHeight,
                                                verticalPadding: 0)
                            .onTapGesture {
                                presenter.routeToRegister(fullName: "", email: "")
                            }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(Theme.current.issWhite.color)
        .alert(isPresented: $presenter.showingAlert) {
            AlertSUI(alertInfo: presenter.alertInfo)
        }
        .edgesIgnoringSafeArea(.all)
        .loading(isLoading: $isLoading)
//        .modifier(SwipeBackGesture {
//            self.presentationMode.wrappedValue.dismiss()
//        })
    }

    private func validated() -> Bool {
        if !phoneErrorState,
           !passwordErrorState {
            return true
        }
        return false
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setImage(Image(systemName: "chevron.backward"))
            .setCallback {
                self.presentationMode.wrappedValue.dismiss()
//                presenter.routeToRoot()
            }
            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setLeftAlignedItem(leftAlignedItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }
}
