//
//  ISSGateway+Extension.swift
//
//
//  Copyright by iSoftStone 2024.
//

import ISSNetwork
import Foundation

extension ISSGateway {
    
    // MARK: TabBar Controller
    
    public static func setTabBarController(_ tabBarController: LoginTabBarControllerLogic) {
        injectTabBarController(tabBarController)
    }

    private static func injectTabBarController(_ tabBarController: LoginTabBarControllerLogic) {
        let internalDepends = PackageDependency.self
        internalDepends.setTabBarController(tabBarController: tabBarController)
    }

    // MARK: Network Monitor

    public static func setNetworkMonitor(_ networkMonitor: NetworkMonitor) {
        injectNetworkMonitor(networkMonitor)
    }

    private static func injectNetworkMonitor(_ networkMonitor: NetworkMonitor) {
        let internalDepends = PackageDependency.self
        internalDepends.setNetworkMonitor(networkMonitor: networkMonitor)
    }
}
