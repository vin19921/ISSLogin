//
//  File 2.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
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

