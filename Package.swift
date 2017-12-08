import PackageDescription
let package = Package(
    name: "Server-Swift",
    targets: [
        Target(name: "Server", dependencies: ["ServerCore"]),
        Target(name: "ServerCore")
    ],
    dependencies: [
        .Package(url: "https://github.com/Hamp-tech/Perfect-HTTP/", majorVersion: 3),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        .Package(url:"https://github.com/PerfectlySoft/Perfect-MongoDB.git", versions: Version(0,0,0)..<Version(10,0,0)),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 3)

        ]
)
