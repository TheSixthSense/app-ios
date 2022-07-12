//
//  Project.swift
//  UtilsManifests
//
//  Created by 문효재 on 2022/07/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(
  name: Module.account.name,
  dependencies: [
    .rxSwift,
    .rxCocoa,
    .rxRelay,
    .rxDataSources,
    .ribs
  ] + [Module.utils, .repository].map(\.project),
  additionalTargets: []
)
