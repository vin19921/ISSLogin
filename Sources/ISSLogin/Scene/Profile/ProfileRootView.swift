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
                            VStack {
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 54, height : 54)
                                    
                                    VStack(spacing: .zero) {
                                        HStack {
                                            Text(presenter.getUserName())
                                                .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                                                    lineHeight: Theme.current.bodyOneBold.lineHeight,
                                                                    verticalPadding: 0)
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack {
                                            Text("0129665980")
                                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                                    verticalPadding: 0)
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                                .padding([.top, .horizontal])

                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.orange)
                                    .frame(height: 69)
                                    .padding()
                            }
                            .padding(.horizontal)
//                            HStack {
//                                VStack(alignment: .leading, spacing: .zero) {
//                                    
//                                    
//                                    Text("View Profile")
//                                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                            verticalPadding: 0)
//                                        .foregroundColor(Color.blue)
//                                        .padding(.top, 8)
//                                        .onTapGesture {
//                                            print("On Tap View Profile")
//                                            presenter.routeToViewProfile()
//                                        }
//                                }
//                                Spacer()
//                            }
//                            .padding()

                            VStack(spacing: .zero) {
                                Button(action: {
                                    presenter.routeToViewProfile()
                                }) {
                                    HStack {
                                        LoginImageAssets.profile.image
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 22, height: 22)
                                            .aspectRatio(contentMode: .fit)
                                        Text("View Profile")
                                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
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
                                    .padding()
                                    //                                .overlay(
                                    //                                    RoundedRectangle(cornerRadius: 16)
                                    //                                        .stroke(Color.gray, lineWidth: 1)
                                    //                                )
                                }
                                
                                Button(action: {
                                    presenter.routeToChangePassword()
                                }) {
                                    HStack {
                                        LoginImageAssets.lock.image
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 22, height: 22)
                                            .aspectRatio(contentMode: .fit)
                                        Text("Change Password")
                                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
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
                                    .padding()
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 16)
//                                            .stroke(Color.gray, lineWidth: 1)
//                                    )
                                }
                                
                                //                            Rectangle().frame(height: 1).foregroundColor(Color.gray)
                                
                                Button(action: {
                                    presenter.routeToUserPreference()
                                }) {
                                    HStack {
                                        LoginImageAssets.love.image
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 22, height: 22)
                                            .aspectRatio(contentMode: .fit)
                                        Text("Task Preferences")
                                            .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                                lineHeight: Theme.current.bodyOneMedium.lineHeight,
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
                                    .padding()
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 16)
//                                            .stroke(Color.gray, lineWidth: 1)
//                                    )
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(" You are not logged in")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                            Spacer()
                        }
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
//                VStack {
                    Button(action: {
                        presenter.logOut()
                    }) {
                        HStack {
                            LoginImageAssets.exit.image
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 22, height: 22)
                                .aspectRatio(contentMode: .fit)
                            Text("Log Out")
                                .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                                    lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                                    verticalPadding: 0)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                        .foregroundColor(Color.red)
                        .background(Color.red.opacity(0.2))
                        .padding()
                        .cornerRadius(12)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 16)
//                                            .stroke(Color.gray, lineWidth: 1)
//                                    )
                    }
//                }
//                .background(Color.red.opacity(0.5))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.red, lineWidth: 1)
//                )
//                .padding(.horizontal)
            }
            .frame(alignment: .bottom)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.red, lineWidth: 1)
            )
            .padding()
        }
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setTitleString("Profile")
            .setTitleFont(Theme.current.subtitle.font)
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
