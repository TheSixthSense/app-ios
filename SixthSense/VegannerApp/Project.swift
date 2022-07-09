import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "VegannerApp",
                          platform: .iOS,
                          dependencies: [
                            .ribs,
                            .rxSwift,
                            .rxCocoa,
                            .rxRelay,
                            .rxDataSources,
                            .alamofire,
                            .moya,
                            .rxMoya,
                            .snapKit,
                            .then,
                            .kingfisher,
                            .swiftyBeaver,
                            .objectMapper,
                            .netfox,
                            .project(target: "Storage", path: .relativeToRoot("Storage"))
                          ],
                          additionalTargets: [])
