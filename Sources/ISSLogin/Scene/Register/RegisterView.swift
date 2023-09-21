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
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)

                switch presenter.state {
                case .isLoading:
                case let .success(viewModel):
                    ScrollView {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Please fill in all the fields.")
                                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                        verticalPadding: 0)
                                Spacer()
                            }
                            
                            ISSTextFieldSUI(inputString: $phoneText,
                                            isErrorState: $phoneErrorState,
                                            viewData: ISSTextFieldSUI.ViewData(placeholderText: "Mobile No.",
                                                                               validateText: "Please enter valid mobile number",
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
                                                                                   validateText: "Password must contain the following:\n- 8 Characters in length.\n- 1 Uppercase (A-Z).\n- 1 Lowercase (a-z).\n- 1 Digit (0-9).\n- 1 Special character.",
                                                                                   regEx: RegExConstants.passwordRegEx,
                                                                                   isRequiredText: "Password must contain the following:\n- 8 Characters in length.\n- 1 Uppercase (A-Z).\n- 1 Lowercase (a-z).\n- 1 Digit (0-9).\n- 1 Special character.",
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
                                presenter.proceedRegistration(request: RegisterModel.Request(
                                    mobileNo: "60\(phoneText)",
                                    password: passwordText,
                                    confirmPassword: cPasswordText,
                                    email: emailText,
                                    name: fullNameText))
                            }) {
                                Text("Confirm")
                                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                        verticalPadding: 8)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(!validated() ? Theme.current.disabledGray1.color : Theme.current.issWhite.color)
                                    .background(!validated() ? Theme.current.grayDisabled.color : Theme.current.issBlack.color)
                                    .cornerRadius(12)
                            }
                            .disabled(!validated()) /// temporary remark
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .alert(isPresented: $presenter.showingAlert) {
                        AlertSUI(alertInfo: AlertInfo(message: viewModel.resultMessage, onDismiss: {
                            print("Dismiss")
                        }))
                    }
                case .failure:
                }
            }
        }
        .background(Theme.current.issWhite.color)
//        .alert(isPresented: $presenter.showingAlert) {
//            Alert(title: Text("Error"),
//                  message: Text("User Existing"),
//                  dismissButton: .default(Text("OK")) {
//                presenter.showingAlert = false
//            })
//        }
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

    func createAlert(title: Text? = nil, message: Text, dismissText: String = "OK", onDismiss: @escaping () -> Void) -> Alert {
        let dismissButton = Alert.Button.default(Text(dismissText), action: onDismiss)
        return Alert(title: title, message: message, dismissButton: dismissButton)
    }
}
