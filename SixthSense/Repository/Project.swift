//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 문효재 on 2022/07/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.library(name: "Repository",
                                dependencies: [
                                  .rxSwift,
                                  .alamofire,
                                  .moya,
                                  .rxMoya,
                                  .project(target: "Utils", path: .relativeToRoot("Utils")),
                                ],
                                additionalTargets: [])
