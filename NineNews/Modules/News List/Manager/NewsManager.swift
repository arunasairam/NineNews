//
//  NewsManager.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

protocol NewsManagerProtocol {
    func loadNews(completion: @escaping (Result<[Asset], Error>) -> Void)
}

class NewsManager: NewsManagerProtocol {
    private let service: NewsAPIServiceProvider
    
    init(service: NewsAPIServiceProvider = NewsAPIService()) {
        self.service = service
    }
    
    func loadNews(completion: @escaping (Result<[Asset], Error>) -> Void) {
        service.fetchNews { result in
            switch result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(News.self, from: data)
                    
                    completion(.success(decodedData.assets))
                } catch let (error) {
                    debugPrint(error.localizedDescription)
                    completion(.failure(JSONError.decodingFailed))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
