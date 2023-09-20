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
    func fetchRegister() -> AnyPublisher<RegisterModel.Response, Error>
}

final class RegisterInteractor: RegisterBusinessLogic {
    private var provider: RegisterDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: RegisterDataProviderLogic) {
        self.provider = provider
    }

    func fetchRegister() -> AnyPublisher<RegisterModel.Response, Error> {
        return Future<RegisterModel.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.fetchRegister()
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(RegisterModel.Response(resultCode: response.resultCode,
                                                            resultMessage: response.resultMessage,
                                                            data: response.data)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}

