//
//  File 2.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import Combine
import Foundation

final class ProfileRootPresenter: ObservableObject {
    private var interactor: ProfileRootBusinessLogic
    private var router: ProfileRootRouter?
    private var cancellables = Set<AnyCancellable>()

    @Published var showingAlert = false
    @Published var errorMessage = ""

    // MARK: Injection

    init(interactor: ProfileRootBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: ProfileRootRouter) {
        self.router = router
    }
}

// MARK: - Routing

extension ProfileRootPresenter {
    func routeToRoot() {
        router?.navigate(to: .rootScreen)
    }

    func routeToChangePassword() {
        router?.navigate(to: .changePasswordScreen)
    }
}

// MARK: - Store User Info

extension ProfileRootPresenter {
//    func getUserInfo(key: UserInfoKey) {
//        interactor.getUserInfo(key: key)
//    }
}

