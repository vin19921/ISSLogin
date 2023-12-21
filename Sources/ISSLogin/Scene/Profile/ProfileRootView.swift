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
                if presenter.isLoggedIn {
                    ScrollView {
                        VStack(spacing: .zero) {
                            HStack {
                                VStack(alignment: .leading, spacing: .zero) {
                                    Text(presenter.getUserName())
                                        .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                            lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                            verticalPadding: 0)
                                    Text("View Profile")
                                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                            verticalPadding: 0)
                                        .foregroundColor(Color.blue)
                                        .padding(.top, 8)
                                        .onTapGesture {
                                            print("On Tap View Profile")
                                            presenter.routeToViewProfile()
                                        }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            
                            Rectangle().frame(height: 1).foregroundColor(Color.gray)
                            
                            Button(action: {
                                presenter.routeToChangePassword()
                            }) {
                                HStack {
                                    Text("Change Password")
                                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                            verticalPadding: 0)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                            verticalPadding: 0)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .foregroundColor(Theme.current.issBlack.color)
                                .padding(.horizontal)
                            }
                            
                            Rectangle().frame(height: 1).foregroundColor(Color.gray)
                        }
                    }
                    .background(Theme.current.backgroundGray.color)
                    .padding(.top)
                } else {
                    VStack {
                        Spacer()
                        Text(" You are not logged in")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                verticalPadding: 0)
                        Button(action: {
                            presenter.routeToLogin()
                        }) {
                            Text("Click Here to Login")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                        }
                        Spacer()
                    }
                    .frame(width: .infinity)
                    .background(Theme.current.backgroundGray.color)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            presenter.updateLoginStatus()
//                presenter.showTabBar()
        }

        if presenter.isLoggedIn {
            ZStack {
                Button(action: {
                    //                    self.presentationMode.wrappedValue.dismiss()
                    presenter.logOut()
                }) {
                    Text("Log Out")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                }
                
            }
            .frame(alignment: .bottom)
            .frame(maxWidth: .infinity)
            .foregroundColor(Theme.current.issBlack.color)
        }
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
//        let leftAlignedItem = ToolBarItemDataBuilder()
//            .setImage(Image(systemName: "chevron.backward"))
//            .setCallback {
//                self.presentationMode.wrappedValue.dismiss()
//            }
//            .build()
//        let toolBarItems = ToolBarItemsDataBuilder()
//            .setLeftAlignedItem(leftAlignedItem)
//            .build()
        let issNavBarData = ISSNavigationBarBuilder()
//            .setToolBarItems(toolBarItems)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }

}
