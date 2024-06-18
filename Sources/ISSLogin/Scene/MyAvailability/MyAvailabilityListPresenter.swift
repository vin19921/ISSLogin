//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/06/2024.
//

import Combine
import Foundation

final class MyAvailabilityListPresenter: ObservableObject {
    private var interactor: MyAvailabilityListBusinessLogic
    private var cancellables = Set<AnyCancellable>()
    private var router: MyAvailabilityListRouter?
    @Published var state = State.isLoading

    enum State {
        case isLoading
        case failure(FailureType)
        case success
    }

    enum FailureType {
        case connectivity
        case internet
        case noData
    }

    // MARK: Injection

    init(interactor: MyAvailabilityListBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: MyAvailabilityListRouter) {
        self.router = router
    }

    func fetchMyAvailabilityList(completionHandler: (() -> Void)? = nil) {
        interactor.fetchMyAvailabilityList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
//                            self.presenterState = .failure(.internet)
                            print("CommonServiceError ::: internet")
                        default:
//                            self.presenterState = .failure(.connectivity)
                            print("CommonServiceError ::: connectivity")
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    print(response)
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - Routing

extension MyAvailabilityListPresenter {
    func routeToTimeFrame() {
        router?.navigate(to: .timeFrameScreen)
    }
}
