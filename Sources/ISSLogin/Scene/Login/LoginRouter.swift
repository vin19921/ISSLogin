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
        case loginScreen
        case registerScreen
        case resetPasswordScreen
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .loginScreen:
            navigator.navigateToLoginScreen()
        case .registerScreen:
            navigator.navigateToRegisterScreen()
        case .resetPasswordScreen:
            navigator.navigateToResetPasswordScreen()
        }
    }
}