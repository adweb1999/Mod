// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OneStateMod",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "OneStateMod",
            targets: ["OneStateMod"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "OneStateMod",
            dependencies: ["Inject"],
            path: "OneStateMod",
            exclude: ["Info.plist"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
