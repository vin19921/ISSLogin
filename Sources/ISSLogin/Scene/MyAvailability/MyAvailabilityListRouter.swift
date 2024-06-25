//
//  MyAvailabilityListRouter.swift
//
//
//  Copyright by iSoftStone 2024.
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

