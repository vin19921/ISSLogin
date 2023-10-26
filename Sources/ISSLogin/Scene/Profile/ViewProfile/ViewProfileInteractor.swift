//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 26/10/2023.
//

import Combine
import Foundation
import ISSNetwork

protocol ViewProfileBusinessLogic {
    func fetchViewProfile(request: ViewProfile.Model.Request) -> AnyPublisher<ViewProfile.Model.Response, Error>
}

final class ViewProfileInteractor: ViewProfileBusinessLogic {
    private var provider: ViewProfileDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: ViewProfileDataProviderLogic) {
        self.provider = provider
    }

    func fetchViewProfile(request: ViewProfile.Model.Request) -> AnyPublisher<ViewProfile.Model.Response, Error> {
        return Future<ViewProfile.Model.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.fetchViewProfile(request:request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(ViewProfile.Model.Response(resultCode: response.resultCode,
                                                                resultMessage: response.resultMessage,
                                                                status: response.status,
                                                                data: response.data)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}

