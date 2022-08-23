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
  case home
  case challenge
  
  // Utils
  case utils

  // Design|UI
  case designSystem
  case uiCore
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
      case .home: return "Home"
      case .challenge: return "Challenge"
      case .designSystem : return "DesignSystem"
      case .uiCore: return "UICore"
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
