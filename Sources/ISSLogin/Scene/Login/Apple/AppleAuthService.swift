//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 04/01/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class AppleAuthService: NSObject, ObservableObject, ASAuthorizationControllerDelegate  {
    
    var action: ((String, String) -> Void)?
    @Binding var isLoading: Bool
    @Published var signedIn:Bool = false
    
    // Unhashed nonce.
    var currentNonce: String?
    
    override init() {
        super.init()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.signedIn = true
                print("Auth state changed, is signed in")
            } else {
                self.signedIn = false
                print("Auth state changed, is signed out")
            }
        }
    }
    
    // MARK: - Password Account
    // Create, sign in, and sign out from password account functions...
    
    //MARK: - Apple sign in
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    // Single-sign-on with Apple
    @available(iOS 13, *)
    func startSignInWithAppleFlow(action: ((String, String) -> Void)?) {
        self.action = action
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
//        authorizationController.performRequests(completionHandler: { (success, error) in
//            // Handle success and extract user information
//            // For example, you can extract full name and email
//            if let fullName = self.fullName, let email = self.email {
//                // Call the action closure with the user's full name and email
//                action(fullName, email)
//            } else {
//                print("Failed to retrieve user information")
//            }
//        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.isLoading.toggle()
                    print("Firebase authentication error: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    print("Firebase login success! User UID: \(user.uid)")
                    
//                    isLoggedIn = true
                    // Fetch user information from Facebook if needed
                    let uid = user.uid
                    let displayName = user.displayName
                    let email = user.email
                    let photoURL = user.photoURL

                    print("UID: \(uid)")
                    print("Display Name: \(displayName ?? "N/A")")
                    print("Email: \(email ?? "N/A")")
                    print("Photo URL: \(photoURL?.absoluteString ?? "N/A")")

                    if let action = self.action {
                        action(displayName ?? "", email ?? "")
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

