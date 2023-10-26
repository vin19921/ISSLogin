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
//                Text("User Logged In")
                HStack(spacing: .zero) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    VStack(alignment: .leading, spacing: 16) {
                        Text(presenter.getUserName())
                            .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                verticalPadding: 0)
                        Text("View Profile")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                verticalPadding: 0)
                            .foregroundColor(Color.blue)
                    }
                    Spacer()
                }
                .background(Color.orange)
                .padding(.horizontal)
                .padding(.bottom)

                Rectangle().frame(height: 1).foregroundColor(Color.gray)

                Button(action: {
                    presenter.viewProfile(request: ViewProfile.Model.Request(mobileNo: "60129665980"))
                }) {
                    Text("View Profile")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 0)
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .foregroundColor(Theme.current.issBlack.color)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 0)
                        .foregroundColor(Theme.current.issBlack.color)
                }

                Rectangle().frame(height: 1).foregroundColor(Color.gray)

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
                        .foregroundColor(Theme.current.issBlack.color)
//                        .background(Theme.current.issBlack.color)
//                        .cornerRadius(12)
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
