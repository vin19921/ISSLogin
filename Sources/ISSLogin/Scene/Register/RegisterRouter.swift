//
//  RegisterRouter.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public struct RegisterRouter {
    private var navigator: RegisterRoutingLogic

    public init(navigator: RegisterRoutingLogic) {
        self.navigator = navigator
    }
}

extension RegisterRouter: RoutingLogic {
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

