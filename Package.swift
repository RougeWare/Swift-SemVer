// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SemVer",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SemVer",
            targets: ["SemVer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KyNorthstar/Swift-EssentiallyAString.git", from: "1.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SemVer",
            dependencies: [
                .product(name: "EssentiallyAString", package: "Swift-EssentiallyAString"),
            ]),
        .testTarget(
            name: "SemVerTests",
            dependencies: ["SemVer"]),
    ]
)
