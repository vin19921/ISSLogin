//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import FirebaseAuth
import Firebase
import GoogleSignIn
import SwiftUI
import ISSTheme

struct GoogleLoginButtonView: View {
//    @State private var isLoggedIn = false
//    @AppStorage("uid") var uid: String?
//    @StateObject var presenter: LoginPresenter
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            if isLoggedIn {
                Text("Logout")
                    .onTapGesture {
                        do {
                            try Auth.auth().signOut()
                            GIDSignIn.sharedInstance()?.signOut()
                            self.user = nil
                        } catch {
                            print("Error signing out: \(error)")
                        }
                    }
            } else {
                Button(action: {
                    // Trigger the Facebook login
                    presenter.signIn()
                    GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                    GIDSignIn.sharedInstance()?.signIn()

                }) {
                    HStack {
                        Spacer()
                        LoginImageAssets.facebook.image
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                        Text("Sign Up with Google")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                verticalPadding: 8)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Theme.current.issWhite.color)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
//                .facebookLoginButtonStyle() // Apply custom button style
            }
        }
        .onAppear {
            // Check if the user is already signed in
            if let user = Auth.auth().currentUser {
                self.user = user
            }
            
            // Set up Google Sign-In delegate
            GIDSignIn.sharedInstance()?.delegate = self
        }
    }
}

extension GoogleLoginButtonView: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google Sign-In error: \(error.localizedDescription)")
        } else {
            let authentication = user.authentication
            let credential = GoogleAuthProvider.credential(
                withIDToken: authentication.idToken,
                accessToken: authentication.accessToken
            )

            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Firebase Auth error: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    self.user = user
                    print("\(user)")
                    isLoggedIn = true
                }
            }
        }
    }
}
