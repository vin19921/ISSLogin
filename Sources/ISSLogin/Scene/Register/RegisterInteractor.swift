//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 20/09/2023.
//

import Combine
import Foundation
import ISSNetwork

protocol RegisterBusinessLogic {
    func fetchRegister(request: Register.Model.Request) -> AnyPublisher<Register.Model.Response, Error>
}

final class RegisterInteractor: RegisterBusinessLogic {
    private var provider: RegisterDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: RegisterDataProviderLogic) {
        self.provider = provider
    }

    func fetchRegister(request: Register.Model.Request) -> AnyPublisher<Register.Model.Response, Error> {
        return Future<Register.Model.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.fetchRegister(request:request)
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(Register.Model.Response(resultCode: response.resultCode,
                                                            resultMessage: response.resultMessage,
                                                            data: response.data)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}

