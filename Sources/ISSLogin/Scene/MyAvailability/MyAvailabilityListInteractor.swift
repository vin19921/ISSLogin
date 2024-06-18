//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 18/06/2024.
//

import Combine
import Foundation
import ISSNetwork

protocol MyAvailabilityListBusinessLogic {
    func fetchMyAvailabilityList() -> AnyPublisher<String, Error>
}

final class MyAvailabilityListInteractor: MyAvailabilityListBusinessLogic {
    private var provider: MyAvailabilityListDataProviderLogic
    private var cancellables = Set<AnyCancellable>()
    
    init(provider: MyAvailabilityListDataProviderLogic) {
        self.provider = provider
    }
    
    func fetchMyAvailabilityList() -> AnyPublisher<String, Error> {
        return Future<String, Error> { [weak self] promise in
            
            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }
            
            self.provider.fetchMyAvailabilityList()
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { response in
                    promise(.success("\(response)"))
                }.store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }
}
