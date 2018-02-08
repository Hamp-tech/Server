import PackageDescription
let package = Package(
    name: "Server",
    targets: [
        Target(name: "Server", dependencies: ["ServerCore"]),
        Target(name: "ServerCore")
    ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 3),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-WebSockets.git", majorVersion: 3),
        .Package(url: "https://github.com/OpenKitten/MongoKitten.git", majorVersion: 4)
        ]
)
