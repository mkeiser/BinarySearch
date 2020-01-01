// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "BinarySearch",
    products: [
        .library(
            name: "BinarySearch",
            targets: ["BinarySearch"]
        )
    ],
    targets: [
        // Our package contains two targets, one for our library
        // code, and one for our tests:
        .target(name: "BinarySearch"),
        .testTarget(
            name: "BinarySearchTests",
            dependencies: ["BinarySearch"]
        )
    ]
)
