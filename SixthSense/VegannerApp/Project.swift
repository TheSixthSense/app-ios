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
    .rxKeyboard,
	.rxAppState
  ] + [Module.storage, .repository, .utils, .account, .designSystem, .splash].map(\.project),
  additionalTargets: []
)
