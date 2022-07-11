//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by 문효재 on 2022/07/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "SixthSense",
    projects: Module.allCases.map(\.path)
)
