// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LuaSwift",
    platforms: [
        .macOS(.v10_13), .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LuaSwift",
            targets: ["LuaSwift"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LuaSwift",
            exclude: ["lua.c", "luac.c"],
            cSettings: [
                .define("LUA_COMPAT_5_3"),
                .define("LUA_USE_JUMPTABLE", to: "0"),
                .define("LUA_USE_MACOSX", to: nil, .when(platforms: [.macOS])),
                .define("LUA_USE_READLINE", to: nil, .when(platforms: [.macOS])),
                .define("LUA_USE_IOS", to: nil, .when(platforms: [.iOS]))
            ]),
        .testTarget(
            name: "LuaSwiftTests",
            dependencies: ["LuaSwift"]),
    ]
)
