//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct ProfileRootView: View {
    
    @ObservedObject private var presenter: ProfileRootPresenter
    
    @State private var isLoading = false

    @State private var email = ""
    
    @State private var isLoggedIn = false
    
    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    init(presenter: ProfileRootPresenter) {
        self.presenter = presenter
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)
                Text("User Logged In")
                HStack(spacing: 16) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    Text(presenter.getUserName())
                }
                .padding(.horizontal)
                Button(action: {
                    presenter.viewProfile(request: ViewProfile.Model.Request(mobileNo: "60129665980"))
                }) {
                    Text("View Profile")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Theme.current.issWhite.color)
                        .background(Theme.current.issBlack.color)
                        .cornerRadius(12)
                }
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    presenter.logOut()
                }) {
                    Text("Log Out")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Theme.current.issWhite.color)
                        .background(Theme.current.issBlack.color)
                        .cornerRadius(12)
                }
            }
        }
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
