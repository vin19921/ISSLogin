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
    @Binding var isLoading: Bool
    let action: ((String, String) -> Void)?

    @State private var isShowingAppleSignIn = false
    @State private var appleSignInError: Error?
    @StateObject private var authService = AppleAuthService()

    var body: some View {
        VStack {
            Button(action: {
                isLoading.toggle()
                authService.startSignInWithAppleFlow(action: action, cancelLoadingAction: {
                    isLoading = false
                })
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
//        .fullScreenCover(isPresented: $isShowingAppleSignIn) {
//            AppleSignInView { result in
//                switch result {
//                case .success(let appleIDCredential):
//                    handleAppleSignInSuccess(appleIDCredential)
//                case .failure(let error):
//                    handleAppleSignInFailure(error)
//                }
//                isShowingAppleSignIn = false
//            }
//        }
    }

//    private func handleAppleSignInSuccess(_ credential: ASAuthorizationAppleIDCredential) {
//        guard let tokenData = credential.identityToken else {
//            print("Unable to fetch identity token.")
//            return
//        }
//
//        guard let tokenString = String(data: tokenData, encoding: .utf8) else {
//            print("Unable to convert identity token to string.")
//            return
//        }
//
//        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nil)
//
//        Auth.auth().signIn(with: credential) { (_, error) in
//            if let error = error {
//                print("Firebase authentication error: \(error.localizedDescription)")
//                appleSignInError = error
//                return
//            }
//
//            print("Successfully signed in with Apple and Firebase.")
//        }
//    }
//
//    private func handleAppleSignInFailure(_ error: Error) {
//        print("Apple Sign In Error: \(error.localizedDescription)")
//        appleSignInError = error
//    }
}

//struct AppleSignInView: UIViewControllerRepresentable {
//    var completionHandler: (Result<ASAuthorizationAppleIDCredential, Error>) -> Void
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIViewController()
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.addTarget(context.coordinator, action: #selector(Coordinator.handleAppleSignIn), for: .touchUpInside)
//
//        let stackView = UIStackView(arrangedSubviews: [authorizationButton])
//        stackView.axis = .vertical
//        stackView.spacing = 16.0
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        controller.view.addSubview(stackView)
//        NSLayoutConstraint.activate([
//            stackView.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor),
//            stackView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor)
//        ])
//
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//
//    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//        var parent: AppleSignInView
//
//        init(_ parent: AppleSignInView) {
//            self.parent = parent
//        }
//
//        @objc func handleAppleSignIn() {
//            let request = ASAuthorizationAppleIDProvider().createRequest()
//            request.requestedScopes = [.fullName, .email]
//
//            let controller = ASAuthorizationController(authorizationRequests: [request])
//            controller.delegate = self
//            controller.presentationContextProvider = self
//            controller.performRequests()
//        }
//
//        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//            return UIApplication.shared.windows.first!
//        }
//
//        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                parent.completionHandler(.success(credential))
//            }
//        }
//
//        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//            parent.completionHandler(.failure(error))
//        }
//    }
//}
