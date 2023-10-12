//
//  File 2.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import Combine
import Foundation

final class UserProfilePresenter: ObservableObject {
    private var interactor: UserProfileBusinessLogic
    private var router: UserProfileRouter?
    private var cancellables = Set<AnyCancellable>()

    @Published var showingAlert = false
    @Published var errorMessage = ""

    // MARK: Injection

    init(interactor: UserProfileBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: UserProfileRouter) {
        self.router = router
    }
}

// MARK: - Routing

extension UserProfilePresenter {
    func routeToRoot() {
        router?.navigate(to: .rootScreen)
    }

    func routeToChangePassword() {
        router?.navigate(to: .changePasswordScreen)
    }
}

// MARK: - Store User Info

extension UserProfilePresenter {
    func getUserInfo(key: UserInfoKey) {
        interactor.getUserInfo(key: key)
    }
}

