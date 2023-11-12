// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Vanilla",
    products: [
        .library(name: "Vanilla", targets: ["Vanilla"])
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc.git", exact: "1.59.2"),
    ],
    targets: [
        .target(name: "Vanilla", dependencies: [
            .product(name: "gRPC-Core", package: "swift.grpc")
        ])
    ]
)
