//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import Foundation

final class LoginPresenter: ObservableObject {

    private var router: LoginRouter?

    // MARK: Injection

    func setRouter(_ router: LoginRouter) {
        self.router = router
    }
}

// MARK: - Routing

extension LoginPresenter {
    func routeToRegister() {
        router?.navigate(to: .registerScreen)
    }

    func routeToResetPassword() {
        router?.navigate(to: .resetPasswordScreen)
    }
}
