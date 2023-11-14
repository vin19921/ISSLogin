//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/11/2023.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct ChangePasswordView: View {
    
    @ObservedObject private var presenter: ChangePasswordPresenter

    @State private var isLoading = false
    
    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    init(presenter: ChangePasswordPresenter) {
        self.presenter = presenter
    }
    
    // MARK: View
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ISSSecureFieldSUI(inputString: $presenter.oldPasswordText,
                                          isErrorState: $presenter.oldPasswordErrorState,
                                          viewData: ISSSecureFieldSUI.ViewData(placeholderText: "Current Password",
                                                                               isRequiredText: "Please enter current password")
                        )
                        .padding(.top)
                        
                        ISSSecureFieldSUI(inputString: $presenter.newPassowrdText,
                                          isErrorState: $presenter.newPasswordErrorState,
                                          viewData: ISSSecureFieldSUI.ViewData(placeholderText: "New Password",
                                                                               validateText: "Password must contain the following:\n- 8 Characters in length.\n- 1 Uppercase (A-Z).\n- 1 Lowercase (a-z).\n- 1 Digit (0-9).\n- 1 Special character.",
                                                                               regEx: RegExConstants.passwordRegEx,
                                                                               isRequiredText: "Password must contain the following:\n- 8 Characters in length.\n- 1 Uppercase (A-Z).\n- 1 Lowercase (a-z).\n- 1 Digit (0-9).\n- 1 Special character."
//                                                                               ,
//                                                                               leadingImageIcon: Image(systemName: "lock")
                                                                              )
                        )
                        
                        ISSSecureFieldSUI(inputString: $presenter.confirmNewPasswordText,
                                          isErrorState: $presenter.confirmNewPasswordErrorState,
                                          compareString: presenter.newPassowrdText,
                                          viewData: ISSSecureFieldSUI.ViewData(placeholderText: "Confirm New Password",
                                                                               validateText: "New Password does not match",
                                                                               isRequiredText: "New Password does not match"
//                                                                               ,
//                                                                               leadingImageIcon: Image(systemName: "lock")
                                                                              )
                        )

                        Button(action: {
                            print("change pw btn")
                            isLoading.toggle()
                            presenter.updateData(completionHandler: {
                                isLoading.toggle()
                            })
                        }) {
                            Text("Change Password")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 8)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(!validated() ? Theme.current.disabledGray1.color : Theme.current.issWhite.color)
                                .background(!validated() ? Theme.current.grayDisabled.color : Theme.current.issBlack.color)
                                .cornerRadius(12)
                        }
                        .disabled(!validated())
//                        .alert(isPresented: $showingAlert) {
//                            Alert(title: Text("Reset Successful"),
//                                  message: Text("Please check your registered email for the new password"),
//                                  dismissButton: .default(Text("OK")) {
////                                presentationMode.wrappedValue.dismiss()
//                                presenter.routeToOTP(mobileNo: "60\(phoneText)")
//                            })
//                        }

                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
        .alert(isPresented: $presenter.showingAlert) {
            AlertSUI(alertInfo: presenter.alertInfo, completionHandler: {
                if presenter.alertInfo.alertType == .success {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .loading(isLoading: $isLoading)
    }

    private func validated() -> Bool {
        if !presenter.oldPasswordErrorState,
           !presenter.newPasswordErrorState,
           !presenter.confirmNewPasswordErrorState {
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
}

