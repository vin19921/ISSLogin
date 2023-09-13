//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import ISSCommonUI
import ISSTheme
import SwiftUI

public struct RegisterView: View {

    @ObservedObject private var presenter: RegisterPresenter
    
    @State private var fullNameText = ""
    @State private var passwordText = ""

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: RegisterPresenter) {
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
                ZStack {
                    VStack(spacing: 16) {
                        HStack(spacing: 0) {
                            Image(systemName: "iphone")
                                .resizable()
                                .frame(width: 20)
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .padding(.vertical, 8)
                                .padding(.leading, 4)
                                .padding(.trailing, 16)

                            Text("+60")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 0)
                            TextField("Mobile No.", text: $fullNameText)
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
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 20)
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                            TextField("Full Name (as Per NRIC)", text: $fullNameText)
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
                                .frame(width: 20)
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                            TextField("Password", text: $fullNameText)
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
                                .frame(width: 20)
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                            TextField("Confirm Password", text: $fullNameText)
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
                            Image(systemName: "envelope")
                                .resizable()
                                .frame(width: 20)
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                            TextField("Email", text: $fullNameText)
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

                        Spacer()

                        Button(action: {
                            print("confirm btn")
                            presenter.routeToOTP()
                        }) {
                            Text("Confirm")
                                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                    verticalPadding: 8)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity) // Expands the button to full screen width
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
}
