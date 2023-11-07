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
                Spacer()
                ZStack(alignment: .center) {
                    VStack(spacing: 16) {
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
//                            if newValue == RegExConstants.minNineDigitRegEx {
//                                phoneErrorState = false
//                            } else {
//                                phoneErrorState = true
//                            }
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
//                                                    self.presentationMode.wrappedValue.dismiss()
//                                                    presenter.routeToRoot()
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

//                        HStack {
                            
//                            FacebookLoginButton()
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 28)
//                                .opacity(0)
////                                .hidden()
//                                .overlay(
//                                    HStack {
//                                        Text("Sign up using Facebook")
//                                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                                verticalPadding: 8)
//                                    }
//                                    .foregroundColor(Theme.current.issWhite.color)
//                                    .background(Color.blue)
//                                    .cornerRadius(12)
//                                )
                        FacebookLoginButtonView(isLoggedIn: $isLoggedIn)
                        GoogleLoginButtonView(isLoggedIn: $isLoggedIn, action: { fullName, email in
                            presenter.routeToRegister(fullName: fullName, email: email)
                        })
                        
//                        }
//                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                            verticalPadding: 8)
//                        .frame(maxWidth: .infinity)
////                        .frame(height: 28)
//                        .foregroundColor(Theme.current.issWhite.color)
//                        .background(Color.blue)
//                        .cornerRadius(12)

//                        HStack {
//                            Text("Sign up using Facebook")
//                            FacebookLoginButton(buttonLabel: "Sign up using Facebook")
////                                .frame(width: 200, height: 28)
//                        }
//                        .padding(.horizontal)
//                        .cornerRadius(12)
                        
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
                }
                .padding(.horizontal)
                Spacer()
            }
        }
        .background(Theme.current.issWhite.color)
        .alert(isPresented: $presenter.showingAlert) {
            AlertSUI(alertInfo: presenter.alertInfo)
        }
        .loading(isLoading: $isLoading)
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
//                self.presentationMode.wrappedValue.dismiss()
                presenter.routeToRoot()
            }
            .build()
//        let leftAlignedSecondItem = ToolBarItemDataBuilder()
//            .setTitleString("Checkout")
//            .setTitleFont(Theme.current.subtitle.font)
//            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setLeftAlignedItem(leftAlignedItem)
//            .setLeftAlignedSecondItem(leftAlignedSecondItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
//            .setBackgroundColor(Theme.current.issWhite.color)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(false)
            .build()
        return issNavBarData
    }
}
