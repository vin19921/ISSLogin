//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/12/2023.
//

import ISSNetwork

/// All dependencies that are required to be initialized once and passed down to the providers should be held here.
public struct PackageDependencyContainer {
    public var networkMonitor: NetworkMonitor?
    public var tabBarController: TabBarControlling?
}

public enum PackageDependency {
    public static var dependencies: PackageDependencyContainer? {
        return packageDependencies
    }
    
    private static var packageDependencies: PackageDependencyContainer = PackageDependencyContainer()
    
    public static func setNetworkMonitor(networkMonitor: NetworkMonitor) {
        packageDependencies.networkMonitor = networkMonitor
    }
    
    public static func setTabBarController(tabBarController: TabBarControllerLogic) {
        packageDependencies.tabBarController = tabBarController
    }
}
