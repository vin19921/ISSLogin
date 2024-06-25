//
//  ResetPasswordRouter.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public struct ResetPasswordRouter {
    private var navigator: ResetPasswordRoutingLogic

    public init(navigator: ResetPasswordRoutingLogic) {
        self.navigator = navigator
    }
}

extension ResetPasswordRouter: RoutingLogic {
    public enum Destination {
        case otpScreen(mobileNo: String)
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case let .otpScreen(mobileNo):
            navigator.navigateToOTPScreen(mobileNo: mobileNo)
        }
    }
}
