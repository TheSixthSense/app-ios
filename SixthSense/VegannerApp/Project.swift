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
                            .snapKit,
                            .then,
                            .kingfisher,
                            .objectMapper,
                            .netfox,
                            .project(target: "Storage", path: .relativeToRoot("Storage")),
                            .project(target: "Repository", path: .relativeToRoot("Repository")),
                            .project(target: "Utils", path: .relativeToRoot("Utils"))
                          ],
                          additionalTargets: [])
