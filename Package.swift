// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SemVer",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SemVer",
            targets: ["SemVer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KyNorthstar/Swift-EssentiallyAString.git", from: "1.0.0"),
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
