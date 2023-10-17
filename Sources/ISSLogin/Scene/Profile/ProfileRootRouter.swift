//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import UIKit

public struct UserProfileRouter {
    private var navigator: UserProfileRoutingLogic

    public init(navigator: UserProfileRoutingLogic) {
        self.navigator = navigator
    }
}

extension UserProfileRouter: RoutingLogic {
    public enum Destination {
        case rootScreen
        case changePasswordScreen
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .rootScreen:
            navigator.navigateToRootScreen()
        case .changePasswordScreen:
            navigator.navigateToChangePasswordScreen()
        }
    }
}
