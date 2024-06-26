//
//  ProfileRootRouter.swift
//
//
//  Copyright by iSoftStone 2024.
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
        case userPreference
        case timeFrameScreen
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
        case .userPreference:
            navigator.navigateToUserPreferenceScreen()
        case .timeFrameScreen:
            navigator.navigateToTimeFrameScreen()
        }
    }
}
