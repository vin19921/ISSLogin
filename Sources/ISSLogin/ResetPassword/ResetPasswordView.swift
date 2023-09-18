//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 18/09/2023.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct ResetPasswordView: View {
    
    @ObservedObject private var presenter: ResetPasswordPresenter
    
    @State private var phoneText = ""
    @State private var phoneErrorState = false
    
    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    init(presenter: ResetPasswordPresenter) {
        self.presenter = presenter
    }
    
    // MARK: View
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)
                
//                ScrollView {
//                    VStack(spacing: 16) {
//                        HStack {
//                            Text("Please fill in all the fields.")
//                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                    verticalPadding: 0)
//                            Spacer()
//                        }
//
//                        ISSTextFieldSUI(inputString: $phoneText,
//                                        isErrorState: $phoneErrorState,
//                                        viewData: ISSTextFieldSUI.ViewData(placeholderText: "Mobile No.",
//                                                                           regEx: RegExConstants.minNineDigitRegEx,
//                                                                           keyboardType: .numberPad,
//                                                                           isRequiredText: "Please enter valid mobile number",
//                                                                           leadingImageIcon: Image(systemName: "iphone"),
//                                                                           prefix: "+60")
//                        )
//
//                        Button(action: {
//                            print("resetpw btn")
//                        }) {
//                            Text("Reset Password")
//                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                    verticalPadding: 8)
//                                .frame(maxWidth: .infinity)
//                                .foregroundColor(!validated() ? Theme.current.disabledGray1.color : Theme.current.issWhite.color)
//                                .background(!validated() ? Theme.current.grayDisabled.color : Theme.current.issBlack.color)
//                                .cornerRadius(12)
//                        }
//                        .disabled(!validated())
//
//                    }
//                    .padding(.horizontal)
//
//                    Spacer()
//                }
            }
        }
    }

    private func validated() -> Bool {
        if !phoneErrorState {
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
