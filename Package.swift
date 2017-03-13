import PackageDescription

let package = Package(
    name: "BeerApp",
    targets: [
        Target(name: "App", dependencies: ["AppLogic"])
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/postgresql-provider.git", majorVersion: 1),
        .Package(url: "https://github.com/kamcma/vapor-xfp-middleware.git", majorVersion: 0)
    ],
    exclude: [
        "Config",
        "Deploy",
        "Public",
        "Resources",
        "Database"
    ]
)
