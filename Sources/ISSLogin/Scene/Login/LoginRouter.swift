//
//  File 2.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
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
        case registerScreen(fullName: String, email: String, action: (() -> Void)?)
        case resetPasswordScreen
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .rootScreen:
            navigator.navigateToRootScreen()
        case let .registerScreen(fullName, email, action):
            navigator.navigateToRegisterScreen(fullName: fullName, email: email, action: action)
        case .resetPasswordScreen:
            navigator.navigateToResetPasswordScreen()
        }
    }
}
