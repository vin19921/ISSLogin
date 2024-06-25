//
//  AppleLoginButtonView.swift
//
//
//  Copyright by iSoftStone 2024.
//

import AuthenticationServices
import Firebase
import SwiftUI
import ISSTheme

struct AppleLoginButtonView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isLoading: Bool
    let action: ((String, String) -> Void)?

    @State private var isShowingAppleSignIn = false
    @State private var appleSignInError: Error?
    @StateObject private var authService = AppleAuthService()

    var body: some View {
        VStack {
            Button(action: {
                isLoading.toggle()
                authService.startSignInWithAppleFlow(action: action, cancelLoadingAction: {
                    isLoading = false
                })
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "apple.logo")
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                    Text("Sign Up with Apple")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Theme.current.white.color)
                .background(Theme.current.black.color)
                .cornerRadius(12)
            }
        }
    }
}
