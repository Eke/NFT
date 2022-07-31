//
//  PixabayService.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import Moya

enum PixabayService {
  case getFeed(page: Int)
}

extension PixabayService: TargetType {
  var baseURL: URL { URL(string: "https://pixabay.com/api/")! }

  var path: String {
    switch self {
    case .getFeed:
      return "/"
    }
  }

  var method: Method {
    switch self {
    case .getFeed:
      return .get
    }
  }

  var task: Task {
    var defaultParams: [String: Any] = [
      "key": "28945376-78ea2ecb68b683ea1ebfc46cf" // TODO: In future will be moved to config for debug / release
    ]
    switch self {
    case .getFeed(let page):
      defaultParams["q"] = "abstract background" // TODO: In future may be dynamic
      defaultParams["page"] = page
      return .requestParameters(parameters: defaultParams, encoding: URLEncoding.queryString)
    }
  }

  var headers: [String: String]? {
    return [
      "Content-type": "application/json"
    ]
  }

  var validationType: ValidationType {
    switch self {
    case .getFeed:
      return .successCodes
    }
  }
}
