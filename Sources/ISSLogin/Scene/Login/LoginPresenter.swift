//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import Combine
//import GoogleSignIn
//import Firebase
//import FirebaseAuth
import Foundation
import ISSCommonUI

final class LoginPresenter: ObservableObject {
    private var interactor: LoginBusinessLogic
    private var router: LoginRouter?
    private var cancellables = Set<AnyCancellable>()

    @Published var showingAlert = false
    @Published var alertInfo = AlertInfo(message: "")

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
                showingAlert.toggle()
                alertInfo = AlertInfo(alertType: .failure, message: message)
            } else {
                saveUserInfo(loginDataModel: data)
                routeToRoot()
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

    func routeToRegister(fullName: String, email: String, action: (() -> Void)?) {
        router?.navigate(to: .registerScreen(fullName: fullName, email: email, ))
    }

    func routeToResetPassword() {
        router?.navigate(to: .resetPasswordScreen)
    }
}

// MARK: - Store User Info

extension LoginPresenter {
    func saveUserInfo(loginDataModel: LoginDataModel) {
        interactor.saveUserInfo(loginDataModel: loginDataModel)
    }
}
