//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/06/2024.
//

import UIKit

public struct MyAvailabilityListRouter {
    private var navigator: MyAvailabilityListRoutingLogic

    public init(navigator: MyAvailabilityListRoutingLogic) {
        self.navigator = navigator
    }
}

extension MyAvailabilityListRouter: RoutingLogic {
    public enum Destination {
        case timeFrameScreen
    }

    public func navigate(to destination: Destination) {
        switch destination {
        case .timeFrameScreen:
            navigator.navigateToTimeFrameScreen()
        }
    }
}

