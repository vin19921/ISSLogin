//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 03/10/2023.
//

import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import ISSTheme
import SwiftUI

public struct FBLoginButtonView: View {
    
    @State private var isLoggedIn = false
    let readPermissions: [Permission] = [.publicProfile, .email, .userFriends, .custom("user_posts")]
    
    // MARK: Injection
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: View
    
    public var body: some View {
        Button(action: {
            print("fb login")
            firebaseLoginWithFacebookAccessToken()
        }) {
            Text("FB Login")
                .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                    lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                    verticalPadding: 8)
                .frame(maxWidth: .infinity)
                .foregroundColor(Theme.current.issWhite.color)
                .background(Color.blue)
                .cornerRadius(12)
        }
    }

//    private func loginWithFacebook() {
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: [.publicProfile, .email], from: nil, viewController: self) { loginResult in
////            if let error = error {
////                // Handle the error
////                print("Facebook login failed with error: \(error)")
////            } else
//            if let loginResult = loginResult {
//                switch loginResult {
//                case .cancelled:
//                    // Handle cancellation
//                    print("Facebook login cancelled.")
//                case .failed(let error):
//                    // Handle failure
//                    print("Facebook login failed with error: \(error)")
//                case .success(let grantedPermissions, _, _):
//                    // Handle successful login
//                    if grantedPermissions.contains(.publicProfile) && grantedPermissions.contains(.email) {
//                        // Facebook login was successful
//                        print("Successful Facebook login")
//                    } else {
//                        // Some permissions were not granted
//                        print("Facebook login failed. Missing permissions.")
//                    }
//                }
//            }
//        }
//    }

//    func login(credential: AuthCredential, completionBlock: @escaping (_ success: Bool) -> Void) {
//        Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
//            print(firebaseUser)
//            completionBlock(error == nil)
//        })
//    }
//
//    func didTapFacebookButton() {
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: readPermissions, configuration: nil, viewController: self, completion: didReceiveFacebookLoginResult)
//    }
//
//    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
//        switch loginResult {
//        case .success:
//            didLoginWithFacebook()
//        case .failed(_): break
//        default: break
//        }
//    }
//
//    fileprivate func didLoginWithFacebook() {
//        // Successful log in with Facebook
//        if let accessToken = AccessToken.current {
//            // If Firebase enabled, we log the user into Firebase
//            FirebaseAuthManager().login(credential: FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)) {[weak self] (success) in
//                guard let `self` = self else { return }
//                var message: String = ""
//                if (success) {
//                    message = "User was sucessfully logged in."
//                } else {
//                    message = "There was an error."
//                }
//                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                self.display(alertController: alertController)
//            }
//        }
//    }

    private func firebaseLoginWithFacebookAccessToken() {
        if let accessToken = AccessToken.current {
            // Access token is available
            let tokenString = accessToken.tokenString
            // You can use the 'tokenString' as needed
            print("Access token: \(tokenString)")
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Firebase login failed with error: \(error)")
                } else if authResult != nil {
                    // Firebase login successful
                    self.isLoggedIn = true
                }
            }
        } else {
            // User is not logged in with Facebook
            print("User is not logged in with Facebook.")
        }

//        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print("Firebase login failed with error: \(error)")
//            } else if authResult != nil {
//                // Firebase login successful
//                self.isLoggedIn = true
//            }
//        }
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

