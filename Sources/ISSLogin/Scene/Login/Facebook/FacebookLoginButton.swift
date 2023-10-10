//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 04/10/2023.
//

import SwiftUI
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth
import Firebase

public struct FacebookLoginButton: UIViewRepresentable {
    public func makeUIView(context: Context) -> FBLoginButton {
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        loginButton.delegate = context.coordinator
        return loginButton
    }

    public func updateUIView(_ uiView: FBLoginButton, context: Context) {
        // Update the view if needed
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public class Coordinator: NSObject, LoginButtonDelegate {
        public func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let result = result {
                print("result ::: \(result)")
            }
            if let token = AccessToken.current {
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                print("credential ::: \(credential)")
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let error = error {
                        print("Firebase authentication error: \(error.localizedDescription)")
                        return
                    }

                    print("Login success!")

                    // Firebase authentication successful
                    if let user = result?.user {
                        let uid = user.uid
                        let displayName = user.displayName
                        let email = user.email
                        let photoURL = user.photoURL

                        print("UID: \(uid)")
                        print("Display Name: \(displayName ?? "N/A")")
                        print("Email: \(email ?? "N/A")")
                        print("Photo URL: \(photoURL?.absoluteString ?? "N/A")")
                        
                        // Now, you can access the user's public profile and email using the Facebook Graph API if needed.
                        // You can make the API request here similarly as shown in the previous response.
                        // Just remember that Firebase already stores the user's basic profile information, so you may not need to fetch it separately.
                    }
                }
            }
        }

        public func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("Logged out")
        }
    }
}

