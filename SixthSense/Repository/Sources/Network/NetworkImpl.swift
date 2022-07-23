//
//  NetworkImpl.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//
import SystemConfiguration

import Foundation
import Moya
import RxMoya
import RxSwift
import Then
import Utils

public final class NetworkImpl: MoyaProvider<MultiTarget>, Network {
  private let disposeBag: DisposeBag = DisposeBag()
  private let log: Loggable
  
  public init(intercepter: NetworkInterceptable?, logger: Loggable) {
    self.log = logger
    let session = MoyaProvider<MultiTarget>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10
    super.init(requestClosure: { endpoint, completion in
      do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        intercepter?.adapt(urlRequest, for: session, completion: completion)
      } catch MoyaError.requestMapping(let url) {
        completion(.failure(MoyaError.requestMapping(url)))
      } catch MoyaError.parameterEncoding(let error) {
        completion(.failure(MoyaError.parameterEncoding(error)))
      } catch {
        completion(.failure(MoyaError.underlying(error, nil)))
      }
    }, session: session, plugins: [])
  }
  
  public func request(_ target: TargetType,
               file: StaticString = #file,
               function: StaticString = #function,
               line: UInt = #line) -> Single<Response> {
    let requestString = "\(target.method.rawValue) \(target.path)"
    return self.rx.request(.target(target))
      .filterSuccessfulStatusCodes()
      .do(
        // FIXME: 모듈로 분리 이후 전역변수로 바꿀 예정이에요
        onSuccess: { [weak self] value in
          self?.log.info("SUCCESS: \(requestString) (\(value.statusCode))")
        },
        onError: { [weak self] error in
          if let response = (error as? MoyaError)?.response {
            if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
              self?.log.warning("FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)")
            } else if let rawString = String(data: response.data, encoding: .utf8) {
              self?.log.warning("FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)")
            } else {
              self?.log.warning("FAILURE: \(requestString) (\(response.statusCode))")
            }
          } else {
            self?.log.error("FAILURE: \(requestString) (\(error)")
          }
        },
        onSubscribed: { [weak self] in
          self?.log.info("REQUEST: \(requestString)")
        }
      )
  }
}

extension Session: Then { }



public final class NetworkInterceptableImpl: NetworkInterceptable {
  public init() { }
  
  public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, MoyaError>) -> Void) {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else {
      completion(.success(urlRequest))
      return
    }
    
    var flags: SCNetworkReachabilityFlags = []
    
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      completion(.failure(MoyaError.underlying(APIError.unknown, nil)))
      return
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    if isReachable && !needsConnection {
      completion(.success(urlRequest))
    } else {
      completion(.failure(MoyaError.underlying(APIError.unknown, nil)))
      return
    }
  }
}
