//
//  MockNewsAPIService.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation
@testable import NineNews

final class MockNewsAPIService: NewsAPIServiceProvider {
    var data: Data?
    var error: Error?
    var fetchNewsCalled = false
    
    func fetchNews(completion: @escaping HTTPResponseCompletionHandler) {
        fetchNewsCalled = true
        
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            completion(.success(data))
        } else {
            completion(.failure(HTTPNetworkError.unknownError))
        }
    }
}
