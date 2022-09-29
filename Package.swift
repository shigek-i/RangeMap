// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RangeMap",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "RangeMap",
            targets: ["RangeMap"]),
    ],
    targets: [
        .target(
            name: "RangeMap",
            dependencies: [])
    ]
)
