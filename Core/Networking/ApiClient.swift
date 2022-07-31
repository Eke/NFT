//
//  ApiClient.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import Moya
import RxSwift

final class ApiClient<Target> where Target: Moya.TargetType {
  let provider: MoyaProvider<Target>

  init(targetType: Target.Type) {
    provider = MoyaProvider<Target>()
  }

  func request<ResponseType: Decodable>(_ target: Target, mapTo objectType: ResponseType.Type) -> Observable<ResponseType> {
    return provider.rx.request(target)
      .map(objectType.self)
      .asObservable()
  }
}
