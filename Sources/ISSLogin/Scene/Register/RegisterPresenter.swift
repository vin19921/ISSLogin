//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import Combine
import Foundation

final class RegisterPresenter: ObservableObject {

    private var router: RegisterRouter?
    private var interactor: RegisterBusinessLogic

    // MARK: Injection

    init(interactor: RegisterBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: RegisterRouter) {
        self.router = router
    }

    func proceedRegistration(request: RegisterModel.Request) {
        fetchRegister(request: request) { result in
            switch result {
            case let .success(response):
//                self.handleEventsResponse(response: success)
                print(response)
            case let .failure(error):
                print(error)
            }
        }
    }

    func fetchRegister(request: RegisterModel.Request, completion: @escaping (Result<RegisterModel.Response, Error>) -> Void) {
        interactor.fetchRegister(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
//                self.isAPICallInProgress = false
                switch completion {
                case let .failure(error):
                    switch error.localizedDescription {
                    case CommonServiceError.internetFailure.localizedDescription:
                        self.state = .failure(.internet)
                    default:
                        self.state = .failure(.connectivity)
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
//                self.isAPICallInProgress = false
//                completion(.success(response))
              
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
}

// MARK: - Routing

extension RegisterPresenter {
    func routeToOTP() {
        router?.navigate(to: .otpScreen)
    }
}
