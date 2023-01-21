//
//  MockURLSession.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation
@testable import NineNews

final class MockURLSession: URLSessionProtocol {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    var cancelRequestCalled: Bool = false
    var dataTaskCalled: Bool = false
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCalled = true
        return handle(completion: completionHandler)
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCalled = true
        return handle(completion: completionHandler)
    }
    
    private func handle(completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if let error = error {
            completion(nil, nil, error)
        } else if let urlResponse = urlResponse,
                  let data = data {
            completion(data, urlResponse, nil)
        } else if let urlResponse = urlResponse {
            completion(nil, urlResponse, nil)
        } else {
            completion(nil, nil, nil)
        }
        
        return URLSessionDataTaskMock(data: data, urlResponse: urlResponse, error: error, completion: completion)
    }
    
    func cancelRequest() {
        cancelRequestCalled = true
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private var data: Data?
    private var urlResponse: URLResponse?
    private var _error: Error?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self._error = error
        self.completionHandler = completion
    }

    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler?(self.data, self.urlResponse, self._error)
        }
    }
    
    override func cancel() {
        super.cancel()
    }
}
