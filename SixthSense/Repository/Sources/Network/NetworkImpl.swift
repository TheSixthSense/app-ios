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
  private let tokenService: AccessTokenService
  
  public init(intercepter: NetworkInterceptable?,
              tokenService: AccessTokenService,
              plugins: [PluginType]) {
    self.tokenService = tokenService
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
      .asObservable()
      .retry(2)
      .retry(when: { [weak self] (error: Observable<APIError>) -> Observable<Void> in
          return error.flatMap { error -> Observable<Void> in
              if error == .tokenExpired {
                  return self?.tokenService.refreshToken(with: self) ?? .empty()
              } else {
                  return .error(error)
              }
          }
      })
      .asSingle()
      .flatMap({ data -> Single<Response> in
          return .just(data)
      })
  }
    
    private func handleErrorResponse(error: MoyaError, target: TargetType) throws -> Single<Response> {
        guard case let .statusCode(status) = error else {
            return .error(APIError.message("문제가 발생했어요! 잠시 후 다시 눌러주세요"))
        }
        
        if status.statusCode == 401 {
            return .error(APIError.tokenExpired)
        }

        guard let json = try JSONSerialization.jsonObject(with: status.data, options: []) as? [String: Any],
            let badRequestResponse = Mapper<ErrorResponse>().map(JSON: json) else {
            return .error(APIError.message("문제가 발생했어요! 잠시 후 다시 눌러주세요"))
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
