import PackageDescription
 
let package = Package(
    name: "Server",
    dependencies: [
        .Package(
        url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
        majorVersion: 2
        )
    ]
)
