//
//  LoginPresenter.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation
import ISSCommonUI

final class LoginPresenter: ObservableObject {
    private var interactor: LoginBusinessLogic
    private var router: LoginRouter?
    private var cancellables = Set<AnyCancellable>()

    @Published var isLoading = false
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
        isLoading.toggle()
        interactor.fetchLogin(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                isLoading.toggle()

                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            print("CommonServiceError ::: internet")
                        default:
                            print("CommonServiceError ::: connectivity")
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleLoginResponse(response: response, completionHandler: completionHandler)
                }
            })
            .store(in: &cancellables)
    }

    private func handleLoginResponse(response: Login.Model.Response, completionHandler: (() -> Void)? = nil) {
        let status = response.status
        let data = response.data

        if let code = response.resultCode,
           let message = response.resultMessage {
            print("resultCode ::: \(code), resultMessage ::: \(message)")

            if code > 0 {
                showingAlert.toggle()
                alertInfo = AlertInfo(alertType: .failure, message: message)
            } else {
                guard let data = data else { return }
                saveUserInfo(loginDataModel: data)
                completionHandler?()
            }
        }
    }
}

// MARK: - Routing

extension LoginPresenter {
    func routeToRoot() {
        router?.navigate(to: .rootScreen)
    }

    func routeToRegister(fullName: String, email: String) {
        if !fullName.isEmpty && !email.isEmpty {
            isLoading.toggle()
        }
        router?.navigate(to: .registerScreen(fullName: fullName, email: email))
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
