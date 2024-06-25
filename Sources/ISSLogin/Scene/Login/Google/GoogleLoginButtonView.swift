//
//  GoogleLoginButtonView.swift
//
//
//  Copyright by iSoftStone 2024.
//

import FirebaseAuth
import Firebase
import GoogleSignIn
import SwiftUI
import ISSTheme

struct GoogleLoginButtonView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isLoading: Bool
    let action: ((String, String) -> Void)?

    var body: some View {
        VStack {
            Button(action: {
                isLoading.toggle()
                googleSignInAction()
            }) {
                HStack {
                    Spacer()
                    LoginImageAssets.google.image
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                    Text("Sign Up with Google")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                        .foregroundColor(Theme.current.issBlack.color)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.current.issBlack.color, lineWidth: 2)
                )
            }
        }
        .onAppear {
            // Check if the user is already signed in
            if let user = Auth.auth().currentUser {
                print("\(user)")
            }
        }
    }

    func googleSignInAction() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config

        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { authentication, error in
            if let error = error {
                print("There is an error signing the user in ==> \(error)")
                isLoading.toggle()
                return
            }
            guard let user = authentication?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
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
        }
    }
}
