//
//  FeedItem.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import Foundation


struct FeedItem: Equatable, Codable {
  let id: Int
  let webformatURL: URL
  let largeImageURL: URL
  let imageWidth: Int
  let imageHeight: Int
  let user: String
  let userImageURL: String
  let likes: Int
  let comments: Int
  let downloads: Int
  let views: Int
  let collections: Int
  let tags: String
  let type: String

  /// `userImageURL` is stored as String because API sometimes returns empty string instead of `nil` or  valid `URL`
  var avatarURL: URL? {
    return URL(string: userImageURL)
  }
}
