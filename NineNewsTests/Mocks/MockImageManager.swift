//
//  MockImageManager.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation
@testable import NineNews

final class MockImageManager: ImageManagerProtocol {
    
    var loadImageCalled: Bool = false
    var data: Data?
    var error: Error?
    
    func loadImageFromCacheOrNetwork(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        loadImageCalled = true
        
        if let data = data {
            completion(.success(data))
        } else if let error = error {
            completion(.failure(error))
        } else {
            completion(.failure(HTTPNetworkError.unknownError))
        }
    }
}
