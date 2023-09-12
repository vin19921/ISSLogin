//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import Foundation

final class RegisterPresenter: ObservableObject {

    private var router: RegisterRouter?

    // MARK: Injection

    func setRouter(_ router: RegisterRouter) {
        self.router = router
    }
}

// MARK: - Routing

extension RegisterPresenter {
    func routeToOTP() {
        router?.navigate(to: .otpScreen)
    }
}
