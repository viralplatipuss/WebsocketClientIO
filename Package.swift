// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebsocketClientIO",
    products: [
        .library(name: "WebsocketClientIO", targets: ["WebsocketClientIO"]),
    ],
    dependencies: [
        .package(url: "https://github.com/viralplatipuss/SimpleFunctional.git", .exact("0.0.10")),
        .package(url: "https://github.com/vapor/websocket-kit.git", .exact("1.1.2")),
    ],
    targets: [
        .target(name: "WebsocketClientIO", dependencies: ["SimpleFunctional", "WebSocket"]),
    ]
)
