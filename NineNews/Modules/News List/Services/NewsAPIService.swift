//
//  NewsAPIService.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

typealias HTTPResponseCompletionHandler = (Result<Data, Error>) -> Void

protocol NewsAPIServiceProvider {
    func fetchNews(completion: @escaping HTTPResponseCompletionHandler)
}

class NewsAPIService: NewsAPIServiceProvider {
    private let network: NineNetworkProtocol
    
    init(network: NineNetworkProtocol = Network()) {
        self.network = network
    }
    
    func fetchNews(completion: @escaping (Result<Data, Error>) -> Void) {
        network.makeAPICall(to: NewsAPI.getNewsList, completion: completion)
    }
}
