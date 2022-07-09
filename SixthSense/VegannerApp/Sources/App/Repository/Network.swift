//
//  Network.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public protocol Network {
  func request(_ target: TargetType, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

public extension Network {
  func request(_ target: TargetType, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<Response> {
    return self.request(target, file: file, function: function, line: line)
  }
}

public protocol NetworkInterceptable {
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, MoyaError>) -> Void)
}
