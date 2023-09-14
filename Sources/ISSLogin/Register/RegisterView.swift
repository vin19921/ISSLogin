//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import Combine
import ISSCommonUI
import ISSTheme
import SwiftUI
import UIKit

public struct RegisterView: View {

    @ObservedObject private var presenter: RegisterPresenter
    
    @State private var phoneText = ""
    @State private var fullNameText = ""
    @State private var passwordText = ""
    @State private var cPasswordText = ""
    @State private var emailText = ""

    @State private var phoneErrorState = false
    @State private var fullNameErrorState = false
    @State private var passwordErrorState = false
    @State private var cPasswordErrorState = false
    @State private var emailErrorState = false

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: RegisterPresenter) {
        self.presenter = presenter
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: .zero) {
                    ISSNavigationBarSUI(data: navigationBarData)
                    
                    VStack(spacing: 16) {
                        ISSTextFieldSUI(inputString: $phoneText,
                                        isErrorState: $phoneErrorState,
                                        viewData: ISSTextFieldSUI.ViewData(placeholderText: "Mobile No.",
                                                                           regEx: RegExConstants.minNineDigitRegEx,
                                                                           keyboardType: .numberPad,
                                                                           isRequiredText: "Please enter valid mobile number",
                                                                           leadingImageIcon: Image(systemName: "iphone"),
                                                                           prefix: "+60")
                        )
                        
                        ISSTextFieldSUI(inputString: $fullNameText,
                                        isErrorState: $fullNameErrorState,
                                        viewData: ISSTextFieldSUI.ViewData(placeholderText: "Full Name (as Per NRIC)",
                                                                           isRequiredText: "Please enter full name",
                                                                           leadingImageIcon: Image(systemName: "person"))
                        )
                        .onReceive(Just(fullNameText)) { newValue in
                            let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                            if filtered != newValue {
                                self.fullNameText = filtered
                            }
                        }
                        
                        ISSSecureFieldSUI(inputString: $passwordText,
                                          isErrorState: $passwordErrorState,
                                          viewData: ISSSecureFieldSUI.ViewData(placeholderText: "Password",
                                                                               validateText: "At least 8 characters in length.\nContains at least 1 uppercase letter (A-Z).\nContains at least 1 lowercase letter (a-z).\nContains at least 1 digit (0-9).\nContains at least 1 special character (not a letter or digit).",
                                                                               regEx: RegExConstants.passwordRegEx,
                                                                               isRequiredText: "At least 8 characters in length.\nContains at least 1 uppercase letter (A-Z).\nContains at least 1 lowercase letter (a-z).\nContains at least 1 digit (0-9).\nContains at least 1 special character (not a letter or digit).",
                                                                               leadingImageIcon: Image(systemName: "lock"))
                        )
                        
                        ISSSecureFieldSUI(inputString: $cPasswordText,
                                          isErrorState: $cPasswordErrorState,
                                          compareString: passwordText,
                                          viewData: ISSSecureFieldSUI.ViewData(placeholderText: "Confirm Password",
                                                                               validateText: "Password does not match",
                                                                               isRequiredText: "Password does not match",
                                                                               leadingImageIcon: Image(systemName: "lock")
                                                                              )
                        )
                        
                        ISSTextFieldSUI(inputString: $emailText,
                                        isErrorState: $emailErrorState,
                                        viewData: ISSTextFieldSUI.ViewData(placeholderText: "Email",
                                                                           validateText: "Please enter valid email",
                                                                           regEx: RegExConstants.emailRegEx,
                                                                           isRequiredText: "Please enter valid email",
                                                                           leadingImageIcon: Image(systemName: "envelope"))
                        )
                        
                        Button(action: {
                            print("confirm btn")
                            presenter.routeToOTP()
                        }) {
                            Text("Confirm")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 8)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity) // Expands the button to full screen width
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                        .disabled(!validated())
                        .foregroundColor(!validated() ? Theme.current.disabledGray1.color : Theme.current.issWhite.color)
                        .background(!validated() ? Theme.current.grayDisabled.color : Theme.current.issBlack.color)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
        .background(Theme.current.issWhite.color)
    }

    private func validated() -> Bool {
        if !phoneErrorState,
           !fullNameErrorState,
           !passwordErrorState,
           !cPasswordErrorState,
           !emailErrorState {
            return true
        }
        return false
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setImage(Image(systemName: "chevron.backward"))
            .setCallback {
                self.presentationMode.wrappedValue.dismiss()
            }
            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setLeftAlignedItem(leftAlignedItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(false)
            .build()
        return issNavBarData
    }
}
