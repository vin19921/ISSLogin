//
//  File 2.swift
//  
//
//  Created by Wing Seng Chew on 07/12/2023.
//

import Foundation

extension ISSGateway {
    
    // MARK: TabBar Controller
    
    public static func setTabBarController(_ tabBarController: TabBarControlling) {
        injectTabBarController(tabBarController)
    }

    private static func injectTabBarController(_ tabBarController: TabBarControlling) {
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
