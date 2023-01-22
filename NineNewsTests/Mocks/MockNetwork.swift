//
//  MockNetwork.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation

@testable import NineNews

class MockNetwork: NineNetworkProtocol {
    
    var data: Data?
    var error: Error?
    var networkRequestCancelled = false
    var makeAPICalled = false
    var loadFromURLCalled = false
    
    func makeAPICall(to api: APIConfirmable, completion: @escaping HTTPResponseCompletionHandler) {
        makeAPICalled = true
        handleData(completion: completion)
    }
    
    func load(from url: URL, completion: @escaping HTTPResponseCompletionHandler) {
        loadFromURLCalled = true
        handleData(completion: completion)
    }
    
    func cancelRequest() {
        networkRequestCancelled = true
    }
    
    private func handleData(completion: @escaping HTTPResponseCompletionHandler) {
        if let data = data {
            completion(.success(data))
        } else if let error = error  {
            completion(.failure(error))
        } else {
            completion(.failure(HTTPNetworkError.unknownError))
        }
    }
}
