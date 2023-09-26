//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 22/09/2023.
//

import Combine
import Foundation
import ISSNetwork

protocol OTPBusinessLogic {
    func fetchOTP(request: OTP.Model.Request) -> AnyPublisher<OTP.Model.Response, Error>
    func validateOTP(request: OTP.Model.Request) -> AnyPublisher<OTP.Model.Response, Error>
}

final class OTPInteractor: OTPBusinessLogic {
    private var provider: OTPDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: OTPDataProviderLogic) {
        self.provider = provider
    }

    func fetchOTP(request: OTP.Model.Request) -> AnyPublisher<OTP.Model.Response, Error> {
        return Future<OTP.Model.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.fetchOTP(request:request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(OTP.Model.Response(resultCode: response.resultCode,
                                                            resultMessage: response.resultMessage,
                                                            data: response.data)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }

    func validateOTP(request: OTP.Model.Request) -> AnyPublisher<OTP.Model.Response, Error> {
        return Future<OTP.Model.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.validateOTP(request:request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(OTP.Model.Response(resultCode: response.resultCode,
                                                            resultMessage: response.resultMessage,
                                                            data: response.data)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}

