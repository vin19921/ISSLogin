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

//    init(interactor: TimeFrameBusinessLogic) {
//        self.interactor = interactor
//    }
}

