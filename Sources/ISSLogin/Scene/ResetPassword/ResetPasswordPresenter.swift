//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 18/09/2023.
//

import Foundation

final class ResetPasswordPresenter: ObservableObject {

    private var router: ResetPasswordRouter?

    // MARK: Injection

    func setRouter(_ router: ResetPasswordRouter) {
        self.router = router
    }
}

// MARK: - Routing

extension ResetPasswordPresenter {
    func routeToOTP(mobileNo: String) {
        router?.navigate(to: .otpScreen(mobileNo: mobileNo))
    }
}
