//
//  Bundle+Extension.swift
//  
//
//  Copyright by iSoftStone 2024.
//

import Foundation

private class MyBundleFinder {}

extension Foundation.Bundle {
    public static var resource: Bundle = {
        let moduleName = "ISSLogin"
        let bundleName = "\(moduleName)_\(moduleName)"

        let candidates = [// Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: MyBundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("Unable to find bundle named \(bundleName)")
    }()
}
