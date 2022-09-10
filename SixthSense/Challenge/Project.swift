//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Allie Kim on 2022/08/01.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(
  name: Module.challenge.name,
  dependencies: [
    .rxSwift,
    .rxCocoa,
    .rxRelay,
    .rxDataSources,
    .ribs,
    .rxGesture,
    .objectMapper,
    .kingfisher,
    .lottie
  ] + [Module.utils, .repository, .designSystem].map(\.project),
  additionalTargets: [],
  resources: .default
)
