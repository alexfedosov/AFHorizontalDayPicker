// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AFHorizontalDayPicker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AFHorizontalDayPicker",
            targets: ["AFHorizontalDayPicker"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .target(
            name: "AFHorizontalDayPicker",
            dependencies: []),
        .testTarget(
            name: "AFHorizontalDayPickerTests",
            dependencies: ["AFHorizontalDayPicker"]),
    ]
)