//
//  NetworkInterceptorProvider.swift
//  RocketReserver
//
//  Created by Roman on 23/4/24.
//

import Foundation
import Apollo
import ApolloAPI

class NetworkInterceptorProvider: DefaultInterceptorProvider {

    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0)
        return interceptors
    }

}
