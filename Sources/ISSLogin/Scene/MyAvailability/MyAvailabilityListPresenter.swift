//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/06/2024.
//

import Combine
import Foundation

final class MyAvailabilityListPresenter: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var router: MyAvailabilityListRouter?
    @Published var state = State.success

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

    func setRouter(_ router: MyAvailabilityListRouter) {
        self.router = router
    }
}

// MARK: - Routing

extension MyAvailabilityListPresenter {
    func routeToTimeFrame() {
        router?.navigate(to: .timeFrameScreen)
    }
}
