//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import Combine
import Foundation

final class RegisterPresenter: ObservableObject {
    private var interactor: RegisterBusinessLogic
    private var router: RegisterRouter?
    private var cancellables = Set<AnyCancellable>()

    @Published var presenterState: PresenterState = .idle
    @Published var showingAlert = false

    enum PresenterState {
        case isLoading
        case failure(FailureType)
        case idle
        case success(Registration.Model.ViewModel)
    }

    enum FailureType {
        case connectivity
        case internet
    }

    // MARK: Injection

    init(interactor: RegisterBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: RegisterRouter) {
        self.router = router
    }

//    func proceedRegistration(request: RegisterModel.Request) {
//        fetchRegister(request: request) { result in
//            switch result {
//            case let .success(response):
//                self.handleRegistrationResponse(response: response)
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }

    func fetchRegister(request: Registration.Model.Request, completionHandler: (() -> Void)? = nil) {
        interactor.fetchRegister(request: request)
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
                            self.presenterState = .failure(.connectivity)
                        default:
                            self.presenterState = .failure(.connectivity)
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleRegistrationResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    private func handleRegistrationResponse(response: Registration.Model.Response) {
        let resultCode = response.resultCode
        let resultMessage = response.resultMessage
        let data = response.data
        
        if resultCode > 0 {
            print("resultCode ::: \(resultCode), resultMessage ::: \(resultMessage)")
            showingAlert = true
            self.presenterState = .success(Registration.Model.ViewModel(message: response.resultMessage,
                                                                        registrationData: response.data))
        } else {
            print("Registration Successful ::: \(data)")
            routeToOTP()
        }
    }
}

//extension RegisterPresenter {
//    enum State {
//        case isLoading
//        case failure(FailureType)
//        case success(RegisterModel.Response)
//    }
//
//    enum FailureType {
//        case connectivity
//        case internet
//    }
//}

// MARK: - Routing

extension RegisterPresenter {
    func routeToOTP() {
        router?.navigate(to: .otpScreen)
    }
}
