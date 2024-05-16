//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

import Combine
import Foundation
import ISSNetwork

protocol TimeFrameBusinessLogic {
    func fetchTimeFrameList(request: TimeFrame.Model.Request) -> AnyPublisher<TimeFrame.Model.Response, Error>
}

final class TimeFrameInteractor: TimeFrameBusinessLogic {
    private var provider: TimeFrameDataProviderLogic
    private var cancellables = Set<AnyCancellable>()
    
    init(provider: TimeFrameDataProviderLogic) {
        self.provider = provider
    }
    
    func fetchTimeFrameList(request: TimeFrame.Model.Request) -> AnyPublisher<TimeFrame.Model.Response, Error> {
        return Future<TimeFrame.Model.Response, Error> { [weak self] promise in
            
            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }
            
            self.provider.fetchTimeFrameList(request:request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success(TimeFrame.Model.Response(
//                        resultCode: response.resultCode,
                                                              resultMessage: response.resultMessage,
//                                                              status: response.status,
                                                              data: response.data)))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}
