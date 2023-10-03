//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 26/09/2023.
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
