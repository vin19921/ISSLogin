//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import Combine
import GoogleSignIn
import Firebase
import FirebaseAuth
import Foundation

final class LoginPresenter: ObservableObject {
    private var interactor: LoginBusinessLogic
    private var router: LoginRouter?
    private var cancellables = Set<AnyCancellable>()

    @Published var showingAlert = false
    @Published var errorMessage = ""

    // MARK: Injection

    init(interactor: LoginBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: LoginRouter) {
        self.router = router
    }

    func fetchLogin(request: Login.Model.Request, completionHandler: (() -> Void)? = nil) {
        interactor.fetchLogin(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                completionHandler?()

                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
//                            self.presenterState = .failure(.internet)
                            print("CommonServiceError ::: internet")
                        default:
//                            self.presenterState = .failure(.connectivity)
                            print("CommonServiceError ::: connectivity")
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleLoginResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    private func handleLoginResponse(response: Login.Model.Response) {
//        let resultCode = response.resultCode
//        let resultMessage = response.resultMessage
        let status = response.status
        let data = response.data

        if let code = response.resultCode,
           let message = response.resultMessage {
            print("resultCode ::: \(code), resultMessage ::: \(message)")

            if code > 0 {
                showingAlert = true
                errorMessage = message
            } else {
                print("Login Successful ::: \(data)")
            }
//            self.presenterState = .success(Registration.Model.ViewModel(message: response.resultMessage,
//                                                                        registrationData: response.data))
        }
//        else {
////            loginDataModel = data
//            print("Login Successful ::: \(data)")
//            //            routeToOTP(mobileNo: data.mobileNo)
//            //        }
//        }
    }
}

// MARK: - Routing

extension LoginPresenter {
    func routeToRoot() {
        router?.navigate(to: .rootScreen)
    }

    func routeToRegister() {
        router?.navigate(to: .registerScreen)
    }

    func routeToResetPassword() {
        router?.navigate(to: .resetPasswordScreen)
    }
}

//
extension LoginPresenter {
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
      Auth.auth().signIn(with: credential) { [weak self] (_, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
            print("Signed In")
//          self.state = .signedIn
        }
      }
    }

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
