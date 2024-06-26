//
//  LoginRouter 2.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public struct LoginRouter {
    private var navigator: LoginRoutingLogic

    public init(navigator: LoginRoutingLogic) {
        self.navigator = navigator
    }
}

extension LoginRouter: RoutingLogic {
    public enum Destination {
        case rootScreen
        case registerScreen(fullName: String, email: String)
        case resetPasswordScreen
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .rootScreen:
            navigator.navigateToRootScreen()
        case let .registerScreen(fullName, email):
            navigator.navigateToRegisterScreen(fullName: fullName, email: email)
        case .resetPasswordScreen:
            navigator.navigateToResetPasswordScreen()
        }
    }
}
