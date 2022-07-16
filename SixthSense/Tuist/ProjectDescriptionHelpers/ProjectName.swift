//
//  ProjectName.swift
//  ProjectDescriptionHelpers
//
//  Created by 문효재 on 2022/07/11.
//

import ProjectDescription

public enum Module {
  case app
  
  // Repository|DataStore
  case repository
  case storage
  
  // Features
  case account
  case splash
  
  // Utils
  case utils

  // Design
  case designSystem
}

extension Module {
  public var name: String {
    switch self {
      case .app: return "VegannerApp"
      case .repository: return "Repository"
      case .storage: return "Storage"
      case .account: return "Account"
      case .utils: return "Utils"
      case .splash: return "Splash"
      case .designSystem : return "DesignSystem"
    }
  }
  
  public var path: ProjectDescription.Path {
    return .relativeToRoot(self.name)
  }
  
  public var project: TargetDependency {
    return .project(target: self.name, path: self.path)
  }
}

extension Module: CaseIterable { }
