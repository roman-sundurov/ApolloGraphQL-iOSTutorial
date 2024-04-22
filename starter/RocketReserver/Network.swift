//
//  Network.swift
//  RocketReserver
//
//  Created by Roman on 22/4/24.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/graphql")!)
}
