// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CombinedLocationManager",
	platforms: [.iOS(.v14)],
	products: [
		.library(name: "CombinedLocationManager", targets: ["CombinedLocationManager"])
	],
	dependencies: [],
	targets: [
		.target(name: "CombinedLocationManager", dependencies: []),
		.testTarget(name: "CombinedLocationManagerTests", dependencies: ["CombinedLocationManager"])
	],
	swiftLanguageVersions: [.v5]
)
