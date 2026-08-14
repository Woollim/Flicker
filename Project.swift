import ProjectDescription

let project = Project(
    name: "Flicker",
    packages: [
        .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.0.0")),
        .remote(url: "https://github.com/Moya/Moya", requirement: .upToNextMajor(from: "15.0.0")),
        .remote(url: "https://github.com/realm/realm-swift", requirement: .upToNextMajor(from: "10.0.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxRealm", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxAlamofire", requirement: .upToNextMajor(from: "6.0.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxKeyboard", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/tid-kijyun/Kanna", requirement: .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: "Flicker",
            destinations: .iOS,
            product: .app,
            bundleId: "WVertex.Flicker",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .file(path: "Flicker/Info.plist"),
            sources: ["Flicker/**"],
            resources: [
                "Flicker/Assets.xcassets",
                "Flicker/UI/**",
            ],
            dependencies: [
                .package(product: "RxSwift"),
                .package(product: "RxCocoa"),
                .package(product: "Moya"),
                .package(product: "RxMoya"),
                .package(product: "RealmSwift"),
                .package(product: "RxRealm"),
                .package(product: "RxAlamofire"),
                .package(product: "RxKeyboard"),
                .package(product: "Kanna"),
            ]
        )
    ]
)
