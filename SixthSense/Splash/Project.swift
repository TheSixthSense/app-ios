//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 문효재 on 2022/07/14.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(
    name: Module.splash.name,
    dependencies: [
        .rxSwift,
        .rxCocoa,
        .rxRelay,
        .ribs,
        .lottie
    ] + [Module.utils, .repository, .account, .home].map(\.project),
    additionalTargets: [],
    resources: .default
)
