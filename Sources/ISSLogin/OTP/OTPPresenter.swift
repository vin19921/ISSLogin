//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import Foundation

final class OTPPresenter: ObservableObject {

    private var router: OTPRouter?

    // MARK: Injection

    func setRouter(_ router: OTPRouter) {
        self.router = router
    }
}

// MARK: - Routing

extension OTPPresenter {
    func routeToRegSuccess() {
        router?.navigate(to: .regSuccessScreen)
    }
}
