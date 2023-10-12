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
                            GIDSignIn.sharedInstance.signOut()
//                            self.user = nil
                        } catch {
                            print("Error signing out: \(error)")
                        }
                    }
            } else {
                Button(action: {
                    googleSignInAction()
                    // Trigger the Facebook login
//                    presenter.signIn()
//                    GIDSignIn.sharedInstance.presentingViewController = UIApplication.shared.windows.first?.rootViewController
//                    guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
//
//                    GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { user, error in
//                        if let error = error {
//                            print(error.localizedDescription)
//                            return
//                          }
//
//                          guard let authentication = user?.authentication, let idToken = authentication.idToken
//                          else {
//                            return
//                          }
//
//                          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                                         accessToken: authentication.accessToken)
//
//                        Auth.auth().signIn(with: credential) { authResult, error in
//                            guard let user = authResult?.user, error == nil else {
//                                self.signUpResultText = error?.localizedDescription ?? "Error Occured"
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                                    self.showCustomAlertLoading = false
//                                })
//                                return}
//                            self.signUpResultText = "\(user.email!)\nSigning Succesfully"
//                            self.isSignUpSucces = true
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
////                                self.showCustomAlertLoading = false
////                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
////                                    self.navigateHome = true
////                                })
//                            })
//                            print("\(user.email!) signed****")
//
//                        }
//                    }


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
//                self.user = user
                print("\(user)")
            }
            
            // Set up Google Sign-In delegate
//            GIDSignIn.sharedInstance()?.delegate = self
        }
    }

    func googleSignInAction() {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { authentication, error in
            if let error = error {
                print("There is an error signing the user in ==> \(error)")
                return
            }
            guard let user = authentication?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    print(error)
                } else {
                    self.email = authResult?.user.email
                    self.photoURL = authResult?.user.photoURL!.absoluteString
                    self.checkIfUserAccountExists()
                    print(authResult)
                }
            }
        }
    }

}

//extension GoogleLoginButtonView: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print("Google Sign-In error: \(error.localizedDescription)")
//        } else {
//            let authentication = user.authentication
//            let credential = GoogleAuthProvider.credential(
//                withIDToken: authentication.idToken,
//                accessToken: authentication.accessToken
//            )
//
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                if let error = error {
//                    print("Firebase Auth error: \(error.localizedDescription)")
//                } else if let user = authResult?.user {
//                    self.user = user
//                    print("\(user)")
//                    isLoggedIn = true
//                }
//            }
//        }
//    }
//}
