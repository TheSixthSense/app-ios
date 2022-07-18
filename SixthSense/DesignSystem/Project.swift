//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Allie Kim on 2022/07/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(
    name: Module.designSystem.name,
    dependencies: [.lottie],
    additionalTargets: [],
    resources: .default
)
