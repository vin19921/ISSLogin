//
//  RegisterView.swift
//
//
//  Copyright by iSoftStone 2024.
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

    @State private var isLoading = false
    @State private var optionSelected: Int? = nil

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

                switch presenter.presenterState {
                case .isLoading:
                    VStack(spacing: 16) { Spacer() }
                case .success(nil):
                    registerView(viewModel: nil)
                case let .success(viewModel):
                    registerView(viewModel: viewModel)
                case let .failure(type):
                    VStack(spacing: 16) { Spacer() }
                }
            }
        }
        .background(Theme.current.issWhite.color)
        .loading(isLoading: $isLoading)
        .onAppear {
            fullNameText = presenter.getFullName()
            emailText = presenter.getEmail()
        }
    }

    @ViewBuilder
    private func registerView(viewModel: Registration.Model.ViewModel?) -> some View {
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
                                isDisabled: .constant(false),
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
                                isDisabled: .constant(false),
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
                                isDisabled: .constant(false),
                                viewData: ISSTextFieldSUI.ViewData(placeholderText: "Email",
                                                                   validateText: "Please enter valid email",
                                                                   regEx: RegExConstants.emailRegEx,
                                                                   isRequiredText: "Please enter valid email",
                                                                   leadingImageIcon: RegisterImageAssets.email.image)
                )

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: .zero) {
                        Toggle("Service Provider", isOn: Binding(
                            get: { self.optionSelected == 1 },
                            set: { _ in self.optionSelected = 1 }
                        ))
                        .toggleStyle(RadioButtonStyle())
                        .frame(width: (UIScreen.main.bounds.width - 32) / 2)

                        Toggle("Customer", isOn: Binding(
                            get: { self.optionSelected == 2 },
                            set: { _ in self.optionSelected = 2 }
                        ))
                        .toggleStyle(RadioButtonStyle())
                        .frame(width: (UIScreen.main.bounds.width - 32) / 2)
                    }
                    .foregroundColor(Color.black)
                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                        verticalPadding: 0)

                    Text(optionSelected == nil ? "Please select user" : "")
                        .foregroundColor(optionSelected == nil ? Color.red : Color.black)
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 0)
                }
                
                Button(action: {
                    isLoading.toggle()
                    presenter.fetchRegister(request: Registration.Model.Request(
                        mobileNo: "60\(phoneText)",
                        password: passwordText,
                        confirmPassword: cPasswordText,
                        email: emailText,
                        name: fullNameText,
                        userType: optionSelected ?? 0
                    ), completionHandler: {
                            isLoading.toggle()
                    })
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
                .disabled(!validated())
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .alert(isPresented: $presenter.showingAlert) {
            AlertSUI(alertInfo: presenter.alertInfo)
        }
    }

    private func validated() -> Bool {
        if !phoneErrorState,
           !fullNameErrorState,
           !passwordErrorState,
           !cPasswordErrorState,
           !emailErrorState,
           optionSelected != nil {
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
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }

    public func setFullName(_ fullName: String) {
        presenter.setFullName(fullName)
    }

    public func setEmail(_ email: String) {
        presenter.setEmail(email)
    }
}

struct RadioButtonStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "largecircle.fill.circle" : "circle")
                configuration.label
                Spacer()
            }
        }
    }
}
