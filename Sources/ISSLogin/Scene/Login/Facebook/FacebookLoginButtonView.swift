//
//  FacebookLoginButtonView.swift
//
//
//  Copyright by iSoftStone 2024.
//

import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth
import Firebase
import SwiftUI
import ISSTheme

struct FacebookLoginButtonView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isLoading: Bool
    let action: ((String, String) -> Void)?

    var body: some View {
        VStack {
            Button(action: {
                isLoading.toggle()
                loginWithFacebook()
            }) {
                HStack {
                    Spacer()
                    LoginImageAssets.facebook.image
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                    Text("Sign Up with Facebook")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Theme.current.issWhite.color)
                .background(Theme.current.fbBlue.color)
                .cornerRadius(12)
            }
        }
    }

    func loginWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                print("Facebook login error: \(error.localizedDescription)")
            } else if let result = result, !result.isCancelled {
                print("Facebook login success")
                // Use Facebook's access token for Firebase authentication
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        print("Firebase authentication error: \(error.localizedDescription)")
                    } else if let user = authResult?.user {
                        print("Firebase login success! User UID: \(user.uid)")
                        
                        isLoggedIn = true
                        // Fetch user information from Facebook if needed
                        let uid = user.uid
                        let displayName = user.displayName
                        let email = user.email
                        let photoURL = user.photoURL

                        print("UID: \(uid)")
                        print("Display Name: \(displayName ?? "N/A")")
                        print("Email: \(email ?? "N/A")")
                        print("Photo URL: \(photoURL?.absoluteString ?? "N/A")")

                        if let action = action {
                            action(displayName ?? "", email ?? "")
                        }
                    }
                }
            } else {
                isLoading.toggle()
                print("result.isCancelled")
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

}
