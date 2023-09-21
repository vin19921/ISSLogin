//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import Foundation

final class OTPPresenter: ObservableObject {

    private var router: OTPRouter?
    private var mobileNo: String = ""

    @Published var remainingTimeInSeconds: Int = 10 // 180

    // MARK: Injection

    func setRouter(_ router: OTPRouter) {
        self.router = router
    }

    func getFormattedRemainingTime() -> String {
        let minutes = remainingTimeInSeconds / 60
        let seconds = remainingTimeInSeconds % 60

        return String(format: "%02i:%02i", minutes, seconds)
    }
}

// MARK: - Routing

extension OTPPresenter {
    func routeToRegSuccess() {
        router?.navigate(to: .regSuccessScreen)
    }
}

extension EventsDetailPresenter {
    func setMobileNo(_ mobileNo: String) {
        self.mobileNo = mobileNo
    }

    func getMobileNo() -> String {
        return mobileNo
    }
}
