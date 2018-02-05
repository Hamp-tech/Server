import PackageDescription
let package = Package(
    name: "Server",
    targets: [
        Target(name: "Server", dependencies: ["ServerCore"]),
        Target(name: "ServerCore")
    ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 3),
        .Package(url:"https://github.com/PerfectlySoft/Perfect-MongoDB.git", versions: Version(0,0,0)..<Version(10,0,0)),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 3),
        .Package(url: "https://github.com/JohnSundell/Files.git", majorVersion: 1),
        ]
)
