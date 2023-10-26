//
//  File 3.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import Combine
import Foundation
import ISSNetwork

protocol ProfileRootBusinessLogic {
    func fetchViewProfile(request: ViewProfile.Model.Request) -> AnyPublisher<ViewProfile.Model.Response, Error>
    func getUserInfo(key: UserInfoKey) -> String
    func logOut()
}

final class ProfileRootInteractor: ProfileRootBusinessLogic {
    private var provider: ProfileRootDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: ProfileRootDataProviderLogic) {
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

    func getUserInfo(key: UserInfoKey) -> String {
        provider.getUserInfo(key: key)
    }

    func logOut() {
        provider.logOut()
    }
}

