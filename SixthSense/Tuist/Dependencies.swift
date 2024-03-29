//
//  Dependencies.swift
//
//  Created by Allie Kim on 2022/04/05.
//
import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
            .ribs,
            .rxSwift,
            .rxDataSources,
            .alamofire,
            .moya,
            .snapKit,
            .then,
            .kingfisher,
            .swiftyBeaver,
            .objectMapper,
            .netfox,
            .lottie,
            .rxKeyboard,
            .rxAppState,
            .rxGesture,
            .jtAppleCalendar
    ],
    platforms: [.iOS]
)

public extension Package {
    static let ribs: Package = .remote(url: "https://github.com/uber/RIBs", requirement: .branch("main"))
    static let rxSwift: Package = .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .branch("main"))
    static let rxDataSources: Package = .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources", requirement: .branch("main"))
    static let alamofire: Package = .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .branch("master"))
    static let moya: Package = .remote(url: "https://github.com/Moya/Moya", requirement: .branch("master"))
    static let snapKit: Package = .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMinor(from: "5.0"))
    static let then: Package = .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "2.7.0"))
    static let kingfisher: Package = .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "5.15.6"))
    static let swiftyBeaver: Package = .remote(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", requirement: .upToNextMajor(from: "1.9.0"))
    static let objectMapper: Package = .remote(url: "https://github.com/tristanhimmelman/ObjectMapper.git", requirement: .upToNextMajor(from: "4.1.0"))
    static let netfox: Package = .remote(url: "https://github.com/kasketis/netfox.git", requirement: .upToNextMajor(from: "1.21.0"))
    static let lottie: Package = .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "3.4.3"))
    static let rxKeyboard: Package = .remote(url: "https://github.com/RxSwiftCommunity/RxKeyboard", requirement: .upToNextMajor(from: "2.0.0"))
    static let rxAppState: Package = .remote(url: "https://github.com/pixeldock/RxAppState", requirement: .upToNextMajor(from: "1.7.1"))
    static let rxGesture: Package = .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMajor(from: "4.0.4"))
    static let jtAppleCalendar: Package = .remote(url: "https://github.com/patchthecode/JTAppleCalendar.git", requirement: .branch("master"))
}
