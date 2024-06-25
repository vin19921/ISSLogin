//
//  ChangePasswordInteractor.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation
import ISSNetwork

protocol ChangePasswordBusinessLogic {
    func changePassword(request: ChangePassword.Model.UpdateRequest) -> AnyPublisher<ChangePassword.Model.Response, Error>
}

final class ChangePasswordInteractor: ChangePasswordBusinessLogic {
    private var provider: ChangePasswordDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: ChangePasswordDataProviderLogic) {
        self.provider = provider
    }

    func changePassword(request: ChangePassword.Model.UpdateRequest) -> AnyPublisher<ChangePassword.Model.Response, Error> {
        return Future<ChangePassword.Model.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.changePassword(request:request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(ChangePassword.Model.Response(resultCode: response.resultCode,
                                                                resultMessage: response.resultMessage,
                                                                status: response.status)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}

