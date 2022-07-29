//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 문효재 on 2022/07/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(
  name: Module.repository.name,
  dependencies: [
    .rxSwift,
    .alamofire,
    .moya,
    .rxMoya
  ] + [Module.storage, .utils].map(\.project),
  additionalTargets: []
)
