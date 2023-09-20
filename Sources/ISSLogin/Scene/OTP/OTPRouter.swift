//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
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
        case regSuccessScreen
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .regSuccessScreen:
            navigator.navigateToRegSuccessScreen()
        }
    }
}
