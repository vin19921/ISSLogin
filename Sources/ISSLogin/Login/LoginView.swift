//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct LoginView: View {

    @ObservedObject private var presenter: LoginPresenter
    
    @State private var emailText = ""
    @State private var passwordText = ""

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }

    // MARK: View

    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)
                //                HStack {
                //                    Spacer()
                //                    Image(systemName: "xmark")
                //                        .resizable()
                //                        .frame(width: 24, height: 24)
                //                        .aspectRatio(contentMode: .fill)
                //                        .foregroundColor(Color.black)
                //                        .onTapGesture {
                //                            presentationMode.wrappedValue.dismiss()
                //                        }
                //                        .padding()
                //                }
                Spacer()
                ZStack(alignment: .center) {
                    VStack(spacing: 16) {
                        HStack {
                            HStack(alignment: .center) {
                                Image(systemName: "iphone")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 4)
                            }
                            .frame(width: 32)
                            
                            TextField("Mobile No.", text: $emailText)
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                        }
                        .frame(height: 32)
                        .padding(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                        )
                        HStack {
                            HStack(alignment: .center) {
                                Image(systemName: "lock")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 4)
                            }
                            .frame(width: 32)
                            
                            SecureField("Password", text: $passwordText)
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                        }
                        .frame(height: 32)
                        .padding(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                        )
                        
                        Button(action: {
                            print("Login btn")
                        }) {
                            Text("Login")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 8)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity) // Expands the button to full screen width
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                        
                        Text("Forget Password")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyThreeRegular.lineHeight,
                                                verticalPadding: 0)
                            .onTapGesture {
                                presenter.routeToRegister()
                            }
                        
                        Text("Register")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyThreeRegular.lineHeight,
                                                verticalPadding: 0)
                            .onTapGesture {
                                presenter.routeToRegister()
                            }
                        
                        
                    }
                }
                Spacer()
            }
        }
        .background(Theme.current.backgroundGray.color)
//        ZStack {
//            ZStack(alignment: .center) {
//                VStack(spacing: 16) {
//                    HStack {
//                        HStack(alignment: .center) {
//                            Image(systemName: "iphone")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(Color.black)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 4)
//                        }
//                        .frame(width: 32)
//
//                        TextField("Mobile No.", text: $emailText)
//                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                verticalPadding: 0)
//                    }
//                    .frame(height: 32)
//                    .padding(.horizontal)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
//                    )
//                    HStack {
//                        HStack(alignment: .center) {
//                            Image(systemName: "lock")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(Color.black)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 4)
//                        }
//                        .frame(width: 32)
//
//                        SecureField("Password", text: $passwordText)
//                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                verticalPadding: 0)
//                    }
//                    .frame(height: 32)
//                    .padding(.horizontal)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
//                    )
//
//                    Button(action: {
//                        print("Login btn")
//                    }) {
//                        Text("Login")
//                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                                verticalPadding: 8)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity) // Expands the button to full screen width
//                            .background(Color.black)
//                            .cornerRadius(12)
//                    }
//
//                    Text("Forget Password")
//                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                            lineHeight: Theme.current.bodyThreeRegular.lineHeight,
//                                            verticalPadding: 0)
//                        .onTapGesture {
//                            presenter.routeToRegister()
//                        }
//
//                    Text("Register")
//                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                            lineHeight: Theme.current.bodyThreeRegular.lineHeight,
//                                            verticalPadding: 0)
//                        .onTapGesture {
//                            presenter.routeToRegister()
//                        }
//
//
//                }
//                .padding()
//                Spacer()
//            }
//        }
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setImage(Image(systemName: "chevron.backward"))
            .setCallback {
                self.presentationMode.wrappedValue.dismiss()
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
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }
}
