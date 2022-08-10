//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 문효재 on 2022/08/01.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(
  name: Module.home.name,
  dependencies: [
    .rxSwift,
    .rxCocoa,
    .rxRelay,
    .rxDataSources,
    .ribs,
    .rxGesture,
    .jtAppleCalendar,
    .rxAppState
  ] + [Module.utils, .repository, .designSystem, .challenge].map(\.project),
  additionalTargets: [],
  resources: .default
)
