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
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            if isLoggedIn {
                Text("Logout")
                    .onTapGesture {
                        signOut()
                    }
            } else {
                Button(action: {
                    // Trigger the Facebook login
                    signIn()
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
    }

    func signIn() {
      // 1
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUser(for: user, with: error)
        }
      } else {
        // 2
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // 3
        let configuration = GIDConfiguration(clientID: clientID)
        
        // 4
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // 5
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
          authenticateUser(for: user, with: error)
        }
      }
    }

    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
      // 1
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      // 2
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      
      // 3
      Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
          self.state = .signedIn
        }
      }
    }

//    func signUpWithGoogle() {
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
//            if let error = error {
//                print("Facebook login error: \(error.localizedDescription)")
//            } else if let result = result, !result.isCancelled {
//                print("Facebook login success")
//                // Use Facebook's access token for Firebase authentication
//                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//                Auth.auth().signIn(with: credential) { (authResult, error) in
//                    if let error = error {
//                        print("Firebase authentication error: \(error.localizedDescription)")
//                    } else if let user = authResult?.user {
//                        print("Firebase login success! User UID: \(user.uid)")
//
//                        isLoggedIn = true
//                        // Fetch user information from Facebook if needed
//                        let uid = user.uid
//                        let displayName = user.displayName
//                        let email = user.email
//                        let photoURL = user.photoURL
//
//                        print("UID: \(uid)")
//                        print("Display Name: \(displayName ?? "N/A")")
//                        print("Email: \(email ?? "N/A")")
//                        print("Photo URL: \(photoURL?.absoluteString ?? "N/A")")
//                    }
//                }
//            }
//        }
//    }

    func signOut() {
      // 1
      GIDSignIn.sharedInstance.signOut()
      
      do {
        // 2
        try Auth.auth().signOut()
        
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }
}

