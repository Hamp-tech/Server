import PackageDescription
let package = Package(
    name: "Server-Swift",
    targets: [
        Target(name: "Server", dependencies: ["ServerCore"]),
        Target(name: "ServerCore")
    ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        ]
)
