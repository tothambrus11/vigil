// swift-tools-version:6.3

import CompilerPluginSupport
import PackageDescription

let _ = Package(name: "vigil",
                dependencies: [
                  .package(url: "https://github.com/compnerd/swift-platform-core",
                           branch: "main"),
                  .package(url: "https://github.com/apple/swift-argument-parser",
                           from: "1.6.0"),
                  .package(url: "https://github.com/apple/swift-syntax",
                           from: "602.0.0"),
                ],
                targets: [
                  .executableTarget(name: "vigil", dependencies: [
                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    .product(name: "WindowsCore", package: "swift-platform-core"),
                    .target(name: "VigilMacroSupport"),
                  ], swiftSettings: [
                    .enableExperimentalFeature("AccessLevelOnImport"),
                  ], plugins: [
                    .plugin(name: "PackageVersion"),
                  ]),
                  .target(name: "VigilMacroSupport", dependencies: [
                    .target(name: "VigilMacros"),
                  ]),
                  .macro(name: "VigilMacros", dependencies: [
                    .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                    .product(name: "SwiftSyntax", package: "swift-syntax"),
                    .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                  ]),
                  .plugin(name: "PackageVersion", capability: .buildTool),
                ])
