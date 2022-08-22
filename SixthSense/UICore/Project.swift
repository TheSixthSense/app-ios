//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Allie Kim on 2022/08/01.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(
    name: Module.uiCore.name,
    dependencies: [
        .snapKit,
        .then
    ] + [Module.designSystem].map(\.project),
    additionalTargets: [],
    resources: .none
)
