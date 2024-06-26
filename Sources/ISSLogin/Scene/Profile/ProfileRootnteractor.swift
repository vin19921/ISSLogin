//
//  ProfileRootInteractor.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation
import ISSNetwork

protocol ProfileRootBusinessLogic {
    func fetchViewProfile(request: ViewProfile.Model.FetchRequest) -> AnyPublisher<ViewProfile.Model.Response, Error>
    func getUserName() -> String
    func getMobileNo() -> String
    func logOut()
    func isLoggedIn() -> Bool
    func hasRunBefore() -> Bool
    func isServiceProvider() -> Bool
}

final class ProfileRootInteractor: ProfileRootBusinessLogic {
    private var provider: ProfileRootDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: ProfileRootDataProviderLogic) {
        self.provider = provider
    }

    func fetchViewProfile(request: ViewProfile.Model.FetchRequest) -> AnyPublisher<ViewProfile.Model.Response, Error> {
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

    func getUserName() -> String {
        provider.getUserName()
    }

    func getMobileNo() -> String {
        provider.getMobileNo()
    }

    func logOut() {
        provider.logOut()
    }

    func isLoggedIn() -> Bool {
        provider.isLoggedIn()
    }

    func hasRunBefore() -> Bool {
        provider.hasRunBefore()
    }

    func isServiceProvider() -> Bool {
        provider.isServiceProvider()
    }
}

