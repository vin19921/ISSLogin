//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 03/10/2023.
//

import SwiftUI
import FacebookLogin
import Firebase
import FBSDKLoginKit

public struct FacebookLoginButton: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Welcome to Your App")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                // Handle Facebook login button action
                self.loginWithFacebook()
            }) {
                Text("Log in with Facebook")
                    .frame(width: 200, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private func loginWithFacebook() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .cancelled:
                print("Facebook login cancelled.")
            case .failed(let error):
                print("Facebook login failed with error: \(error)")
            case .success(let grantedPermissions, _, _):
                if grantedPermissions.contains(.publicProfile) && grantedPermissions.contains(.email) {
                    if let token = AccessToken.current {
                        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                        
                        Auth.auth().signIn(with: credential) { _, error in
                            if let error = error {
                                print("Firebase authentication with Facebook error: \(error.localizedDescription)")
                            } else {
                                print("Firebase login successful!")
                                // You can perform further actions after successful login
                            }
                        }
                    }
                } else {
                    print("Facebook login failed. Missing permissions.")
                }
            }
        }
    }
}

