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
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
                }
                Spacer()
            }
            ZStack(alignment: .center) {
//                Spacer()
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "iphone")
                            .resizable()
                            .scaledToFit()
//                            .frame(height: 16)
//                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
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
                        Image(systemName: "lock")
                            .resizable()
//                            .frame(height: 16)
                            .scaledToFit()
//                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                        TextField("Password", text: $passwordText)
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
//                        .foregroundColor(.blue)
                        .onTapGesture {
                            presenter.routeToRegister()
                        }

                    Text("Register")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyThreeRegular.lineHeight,
                                            verticalPadding: 0)
//                        .foregroundColor(.blue)
                        .onTapGesture {
                            presenter.routeToRegister()
                        }
                  
                    
                }
                .padding()
//                Spacer()
            }
        }
//        ZStack(alignment: .bottom) {
//            VStack(spacing: 16) {
//                Text("Forget Password")
//                    .fontWithLineHeight(font: Theme.current.bodyThreeRegular.uiFont,
//                                        lineHeight: Theme.current.bodyThreeRegular.lineHeight,
//                                        verticalPadding: 0)
//                    .foregroundColor(.blue)
//                    .onTapGesture {
//                        presenter.routeToRegister()
//                    }
//
//                Text("Register")
//                    .fontWithLineHeight(font: Theme.current.bodyThreeRegular.uiFont,
//                                        lineHeight: Theme.current.bodyThreeRegular.lineHeight,
//                                        verticalPadding: 0)
//                    .foregroundColor(.blue)
//                    .onTapGesture {
//                        presenter.routeToRegister()
//                    }
//            }
//        }
    }
}
