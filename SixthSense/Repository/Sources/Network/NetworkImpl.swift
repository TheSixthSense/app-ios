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
import ObjectMapper

public final class NetworkImpl: MoyaProvider<MultiTarget>, Network {
  private let disposeBag: DisposeBag = DisposeBag()
    
  public init(intercepter: NetworkInterceptable?, plugins: [PluginType]) {
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
    }, session: session, plugins: plugins)
  }
  
  public func request(_ target: TargetType,
               file: StaticString = #file,
               function: StaticString = #function,
               line: UInt = #line) -> Single<Response> {
    return self.rx.request(.target(target))
      .filterSuccessfulStatusCodes()
      .catch {
        guard let error = $0 as? MoyaError else {
            return .error(APIError.message($0.localizedDescription))
        }
        
        return try self.handleErrorResponse(error: error, target: target)
      }      
  }
    
    private func handleErrorResponse(error: MoyaError, target: TargetType) throws -> Single<Response> {
        guard case let .statusCode(status) = error else {
            return .error(APIError.message("알 수 없는 에러 발생"))
        }
        
        if status.statusCode == 401 {
            return .error(APIError.tokenExpired)
        }

        guard let json = try JSONSerialization.jsonObject(with: status.data, options: []) as? [String: Any],
            let badRequestResponse = Mapper<ErrorResponse>().map(JSON: json) else {
            return .error(APIError.message("알 수 없는 에러 발생"))
        }

        let errorMessage = APIError.error(badRequestResponse, status.statusCode.description)
        return .error(errorMessage)
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
