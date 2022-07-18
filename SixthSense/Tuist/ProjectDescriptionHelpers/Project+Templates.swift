import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension TargetDependency {
    static let ribs: TargetDependency = .external(name: "RIBs")
    static let rxSwift: TargetDependency = .external(name: "RxSwift")
    static let rxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let rxRelay: TargetDependency = .external(name: "RxRelay")
    static let rxDataSources: TargetDependency = .external(name: "RxDataSources")
    static let alamofire: TargetDependency = .external(name: "Alamofire")
    static let moya: TargetDependency = .external(name: "Moya")
    static let rxMoya: TargetDependency = .external(name: "RxMoya")
    static let snapKit: TargetDependency = .external(name: "SnapKit")
    static let then: TargetDependency = .external(name: "Then")
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
    static let swiftyBeaver: TargetDependency = .external(name: "SwiftyBeaver")
    static let objectMapper: TargetDependency = .external(name: "ObjectMapper")
    static let netfox: TargetDependency = .external(name: "netfox")
    static let rxKeyboard: TargetDependency = .external(name: "RxKeyboard")
    static let lottie: TargetDependency = .external(name: "Lottie")
}

extension Project {
    static let organizationName = "kr.co.thesixthsense"
}

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency],
        additionalTargets: [String]
    ) -> Project {

        let targets = makeAppTargets(
            name: name,
            platform: platform,
            dependencies: dependencies)

        let schemes = makeAppScheme(name: name)

        let settings = makeAppSettings()

        return Project(name: name,
                       organizationName: organizationName,
                       settings: settings,
                       targets: targets,
                       schemes: schemes)
    }

    // MARK: - Private

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency]
    ) -> [Target] {

        let platform: Platform = platform

//        let targetScripts = [
//            TargetScript.pre(
//                script: "\(name)/scripts/FBCrashlyticsRunScript.sh",
//                name: "Firebase Crashlytics")
//        ]

        let settings = makeAppSettings()

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: organizationName,
            deploymentTarget: .iOS(targetVersion: "13.0",
                                   devices: [.iphone]),
            infoPlist: .file(path: "Supporting Files/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies,
            settings: settings
        )

        let devTarget = Target(
            name: "\(name)Dev",
            platform: platform,
            product: .app,
            bundleId: "\(organizationName).dev",
            deploymentTarget: .iOS(targetVersion: "13.0",
                                   devices: [.iphone]),
            infoPlist: .file(path: "Supporting Files/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .relativeToRoot("\(name)/\(name)Dev.entitlements"),
            dependencies: dependencies,
            settings: settings
        )

//        let unitTestTarget = Target(
//            name: "\(name)Tests",
//            platform: platform,
//            product: .unitTests,
//            bundleId: "kr.co.thesixthsense",
//            infoPlist: .default,
//            sources: ["\(name)Tests/**"],
//            dependencies: dependencies
//        )

//        let uiTestTarget = Target(
//            name: "\(name)UITests",
//            platform: platform,
//            product: .uiTests,
//            bundleId: "kr.co.thesixthsense",
//            infoPlist: .default,
//            sources: ["\(name)UITests/**"],
//            dependencies: dependencies
//        )

        return [mainTarget, devTarget]
    }

    private static func makeAppScheme(name: String) -> [Scheme] {
        return [
            Scheme(
                name: "\(name)-Dev",
                shared: true,
                buildAction: .buildAction(targets: ["\(name)Dev"]),
                testAction: .targets(["\(name)UITests"]),
                runAction: .runAction(configuration: .debug,
                                      executable: "\(name)Dev"),
                archiveAction: .archiveAction(configuration: .debug)
            ),
            Scheme(
                name: "\(name)-Release",
                shared: true,
                buildAction: .buildAction(targets: ["\(name)"]),
                runAction: .runAction(configuration: .release,
                                      executable: "\(name)"),
                archiveAction: .archiveAction(configuration: .release)
            )
        ]
    }

    private static func makeAppSettings() -> Settings {

        let debug = Configuration.debug(
            name: ConfigurationName.debug,
            settings: [:],
            xcconfig: .relativeToRoot("Configs/debug.xcconfig"))

        let release = Configuration.release(
            name: ConfigurationName.release,
            settings: [:],
            xcconfig: .relativeToRoot("Configs/release.xcconfig"))

        return Settings.settings(configurations: [debug, release])
    }
}

// MARK: - Framework
extension Project {
  public static func library(
    name: String,
    dependencies: [TargetDependency],
    additionalTargets: [String],
    resources: ProjectDescription.ResourceFileElements? = nil
  ) -> Project {
    let settings: Settings = makeAppSettings()
    
    let targets: [Target] = [
      Target(
        name: name,
        platform: .iOS,
        product: .staticLibrary,
        bundleId: "\(organizationName).\(name)",
        deploymentTarget: .iOS(targetVersion: "13.0",
                               devices: [.iphone]),
        infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
        sources: ["Sources/**"],
        resources: resources,
        dependencies: dependencies,
        settings: settings
      )
    ]
    
    let schemes: [Scheme] = [
      Scheme(
        name: "\(name)",
        shared: true,
        buildAction: .buildAction(targets: [".\(name)"]),
        testAction: .targets(["\(name)Tests"]),
        runAction: .runAction(configuration: .debug,
                              executable: "\(name)"),
        archiveAction: .archiveAction(configuration: .debug)
      )
    ]
    
    
    return Project(name: name,
                   organizationName: organizationName,
                   settings: settings,
                   targets: targets,
                   schemes: schemes)
  }
}
