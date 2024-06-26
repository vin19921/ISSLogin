//
//  ViewProfileInteractor.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation
import ISSNetwork

protocol ViewProfileBusinessLogic {
    func fetchViewProfile(request: ViewProfile.Model.FetchRequest) -> AnyPublisher<ViewProfile.Model.Response, Error>
    func updateProfile(request: ViewProfile.Model.UpdateRequest) -> AnyPublisher<ViewProfile.Model.Response, Error>
    func saveUserInfo(viewProfileDataModel: ViewProfileDataModel)
}

final class ViewProfileInteractor: ViewProfileBusinessLogic {
    private var provider: ViewProfileDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: ViewProfileDataProviderLogic) {
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

    func updateProfile(request: ViewProfile.Model.UpdateRequest) -> AnyPublisher<ViewProfile.Model.Response, Error> {
        return Future<ViewProfile.Model.Response, Error> { [weak self] promise in

            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }

            self.provider.updateProfile(request:request)
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

    func saveUserInfo(viewProfileDataModel: ViewProfileDataModel) {
        provider.saveUserInfo(viewProfileDataModel: viewProfileDataModel)
    }
}

