//
//  ResetPasswordPresenter.swift
//
//
//  Copyright by iSoftStone 2024.
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
