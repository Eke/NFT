//
//  FeedResponse.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import Foundation

struct FeedResponse: Codable, Equatable {
  let total: Int
  let totalHits: Int
  let hits: [FeedItem]
}
