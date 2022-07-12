import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: Module.app.name,
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
    .rxKeyboard
  ] + [Module.storage, .repository, .utils, .account, .designSystem].map(\.project),
  additionalTargets: []
)
