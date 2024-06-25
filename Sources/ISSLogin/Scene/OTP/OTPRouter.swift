//
//  OTPRouter.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public struct OTPRouter {
    private var navigator: OTPRoutingLogic

    public init(navigator: OTPRoutingLogic) {
        self.navigator = navigator
    }
}

extension OTPRouter: RoutingLogic {
    public enum Destination {
        case loginScreen
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .loginScreen:
            navigator.navigateToLoginScreen()
        }
    }
}
