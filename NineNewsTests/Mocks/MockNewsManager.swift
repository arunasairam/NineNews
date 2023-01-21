//
//  MockNewsManager.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 23/1/2023.
//

import Foundation
@testable import NineNews

final class MockNewsManager: NewsManagerProtocol {
    var assets: [Asset]?
    var error: Error?
    var loadNewsCalled: Bool = false
    
    func loadNews(completion: @escaping (Result<[Asset], Error>) -> Void) {
        loadNewsCalled = true
        
        if let assets = assets {
            completion(.success(assets))
        } else if let error = error {
            completion(.failure(error))
        } else {
            completion(.failure(HTTPNetworkError.unknownError))
        }
    }
}
