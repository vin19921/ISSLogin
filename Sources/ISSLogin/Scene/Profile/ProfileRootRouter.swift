//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import UIKit

public struct ProfileRootRouter {
    private var navigator: ProfileRootRoutingLogic

    public init(navigator: ProfileRootRoutingLogic) {
        self.navigator = navigator
    }
}

extension ProfileRootRouter: RoutingLogic {
    public enum Destination {
        case rootScreen
        case loginScreen
        case viewProfileScreen
        case changePasswordScreen
        case userPreference(hasRunBefore: Bool)
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .rootScreen:
            navigator.navigateToRootScreen()
        case .loginScreen:
            navigator.navigateToLoginScreen()
        case .viewProfileScreen:
            navigator.navigateToViewProfileScreen()
        case .changePasswordScreen:
            navigator.navigateToChangePasswordScreen()
        case let .userPreference(hasRunBefore):
            navigator.navigateToUserPreferenceScreen(hasRunBefore: hasRunBefore)
        }
    }
}
