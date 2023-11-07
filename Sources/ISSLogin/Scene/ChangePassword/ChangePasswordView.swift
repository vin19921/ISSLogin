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
//                        HStack {
//                            Text("Please enter your registered mobile number.")
//                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                    verticalPadding: 0)
//                            Spacer()
//                        }

                        ISSTextFieldSUI(inputString: $presenter.oldPasswordText,
                                        isErrorState: $presenter.oldPasswordErrorState,
                                        isDisabled: .constant(false),
                                        viewData: ISSTextFieldSUI.ViewData(placeholderText: "Old Password",
//                                                                           validateText: "Please enter valid old password",
//                                                                           regEx: RegExConstants.minNineDigitRegEx,
//                                                                           keyboardType: .numberPad,
                                                                           isRequiredText: "Please enter old password",
//                                                                           leadingImageIcon: Image(systemName: "iphone"),
//                                                                           prefix: "+60"
                                                                          )
                        )

                        Button(action: {
                            print("resetpw btn")
//                            showingAlert.toggle()
//                            presenter.routeToOTP(mobileNo: "60\(phoneText)")
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
    }

    private func validated() -> Bool {
        if !presenter.oldPasswordErrorState {
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

