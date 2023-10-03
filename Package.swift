// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ISSLogin",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ISSLogin",
            targets: ["ISSLogin"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/iSoftStoneMY/iSSBooking-iOS-Theme", branch: "develop"),
        .package(url: "https://github.com/iSoftStoneMY/iSSBooking-iOS-CommonUI", branch: "develop"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "10.15.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", exact: "16.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ISSLogin",
            dependencies: [.product(name: "ISSTheme", package: "iSSBooking-iOS-Theme"),
                           .product(name: "ISSCommonUI", package: "iSSBooking-iOS-CommonUI"),
                           .product(name: "Firebase", package: "Firebase"),
                           .product(name: "Facebook", package: "Facebook"),
            ]),
        .testTarget(
            name: "ISSLoginTests",
            dependencies: ["ISSLogin"]),
    ]
)
