//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 09/11/2023.
//

import AuthenticationServices
import Firebase
import SwiftUI
import ISSTheme

struct AppleLoginButtonView: View {
    @Binding var isLoggedIn: Bool
    let action: ((String, String) -> Void)?

    @State private var isShowingAppleSignIn = false
    @State private var appleSignInError: Error?

    var body: some View {
        VStack {
            Button(action: {
                isShowingAppleSignIn.toggle()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "apple.logo")
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                    Text("Sign Up with Apple")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Theme.current.white.color)
                .background(Theme.current.black.color)
                .cornerRadius(12)
            }
        }
        .fullScreenCover(isPresented: $isShowingAppleSignIn) {
            AppleSignInView { result in
                switch result {
                case .success(let appleIDCredential):
                    handleAppleSignInSuccess(appleIDCredential)
                case .failure(let error):
                    handleAppleSignInFailure(error)
                }
                isShowingAppleSignIn = false
            }
        }
    }

    private func handleAppleSignInSuccess(_ credential: ASAuthorizationAppleIDCredential) {
        guard let tokenData = credential.identityToken else {
            print("Unable to fetch identity token.")
            return
        }

        guard let tokenString = String(data: tokenData, encoding: .utf8) else {
            print("Unable to convert identity token to string.")
            return
        }

        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nil)

        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print("Firebase authentication error: \(error.localizedDescription)")
                appleSignInError = error
                return
            }

            print("Successfully signed in with Apple and Firebase.")
        }
    }

    private func handleAppleSignInFailure(_ error: Error) {
        print("Apple Sign In Error: \(error.localizedDescription)")
        appleSignInError = error
    }
}

struct AppleSignInView: UIViewControllerRepresentable {
    var completionHandler: (Result<ASAuthorizationAppleIDCredential, Error>) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ASAuthorizationController {
        let controller = ASAuthorizationController(authorizationRequests: [ASAuthorizationAppleIDProvider().createRequest()])
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: ASAuthorizationController, context: Context) {}

    class Coordinator: NSObject, ASAuthorizationControllerDelegate {
        var parent: AppleSignInView

        init(_ parent: AppleSignInView) {
            self.parent = parent
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                parent.completionHandler(.success(credential))
            }
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            parent.completionHandler(.failure(error))
        }
    }
}
