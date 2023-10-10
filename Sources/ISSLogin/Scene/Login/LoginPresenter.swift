//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import Combine
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
        let resultCode = response.resultCode
        let resultMessage = response.resultMessage
        let status = response.status
        let data = response.data
        
        if resultCode > 0 {
            print("resultCode ::: \(resultCode), resultMessage ::: \(resultMessage)")
            showingAlert = true
            errorMessage = resultMessage
//            self.presenterState = .success(Registration.Model.ViewModel(message: response.resultMessage,
//                                                                        registrationData: response.data))
        } else {
            loginDataModel = data
            print("Login Successful ::: \(data)")
//            routeToOTP(mobileNo: data.mobileNo)
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
