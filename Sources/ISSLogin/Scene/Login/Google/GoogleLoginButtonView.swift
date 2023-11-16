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
    @Binding var isLoading: Bool
    let action: ((String, String) -> Void)?

    var body: some View {
        VStack {
//            if isLoggedIn {
//                Text("Logout")
//                    .onTapGesture {
//                        do {
//                            try Auth.auth().signOut()
//                            GIDSignIn.sharedInstance.signOut()
////                            self.user = nil
//                            isLoggedIn = false
//                        } catch {
//                            print("Error signing out: \(error)")
//                        }
//                    }
//            }
//            else {
                Button(action: {
                    isLoading.toggle()
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
//                .facebookLoginButtonStyle() // Apply custom button style
            }
//        }
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
