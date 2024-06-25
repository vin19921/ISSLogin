//
//  LoginInteractor.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation
import ISSNetwork

protocol LoginBusinessLogic {
    func fetchLogin(request: Login.Model.Request) -> AnyPublisher<Login.Model.Response, Error>
    func saveUserInfo(loginDataModel: LoginDataModel)
}

final class LoginInteractor: LoginBusinessLogic {
    private var provider: LoginDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: LoginDataProviderLogic) {
        self.provider = provider
    }

    func fetchLogin(request: Login.Model.Request) -> AnyPublisher<Login.Model.Response, Error> {
        return Future<Login.Model.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.fetchLogin(request:request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(Login.Model.Response(resultCode: response.resultCode,
                                                          resultMessage: response.resultMessage,
                                                          status: response.status,
                                                          data: response.data)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }

    func saveUserInfo(loginDataModel: LoginDataModel) {
        provider.saveUserInfo(loginDataModel: loginDataModel)
    }
}

