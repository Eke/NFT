//
//  Appdelegate+Resolver.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import Resolver

/// Resolves extension to register all services
extension Resolver: ResolverRegistering {
  /// Resolver automatically calls the registerAllServices function the very first time it's asked to resolve a particular service.
  /// But as is, it's not very useful until you actually register some classes.
  public static func registerAllServices() {
    Resolver.register { UserLocalRepository() as UserRepositoring }.scope(.shared)
    Resolver.register { AuthNavigator() }.scope(.shared)
  }
}
