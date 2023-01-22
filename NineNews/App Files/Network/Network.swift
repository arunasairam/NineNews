//
//  Network.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

protocol NineNetworkProtocol {
    func makeAPICall(to api: APIConfirmable, completion: @escaping HTTPResponseCompletionHandler)
    func load(from url: URL, completion: @escaping HTTPResponseCompletionHandler)
    func cancelRequest()
}

class Network: NineNetworkProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = NineURLSession()) {
        self.session = session
    }
    
    func makeAPICall(to api: APIConfirmable, completion: @escaping HTTPResponseCompletionHandler) {
        guard let request = configureURLRequest(api) else {
            return completion(.failure(HTTPNetworkError.badRequest))
        }
        
        perform(request: request, completion: completion)
    }
    
    private func configureURLRequest(_ api: APIConfirmable) -> URLRequest? {
        guard let url = Enviroment.baseURL?.appendingPathComponent(api.path),
              var urlComponents =  URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        
        /* Though the current end point used in this assessment does not require any query parameters. But I have made this function capable of assigning query parameters as well. */
        if let params = api.queryParameters,
           !params.isEmpty {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in params {
                if let paramValue = value {
                    let queryItem = URLQueryItem(name: key, value: "\(paramValue)")
                    queryItems.append(queryItem)
                }
            }
            
            urlComponents.queryItems = queryItems
        }
        
        guard let finalURL = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.timeoutInterval = 10
        urlRequest.httpMethod = api.method.value
        
        // Can be used for post requests
        if let data = api.body {
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
    
    private func perform(request: URLRequest, completion: @escaping HTTPResponseCompletionHandler) {
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error as? NSError {
                    // Checking for internet connectivity error
                    switch error.code {
                    case NSURLErrorTimedOut where error.domain == NSURLErrorDomain,
                        NSURLErrorNotConnectedToInternet where error.domain == NSURLErrorDomain:
                        completion(.failure(HTTPNetworkError.networkError))
                        
                    default:
                        break
                    }
                    
                    completion(.failure(error))
                    return
                }
                
                // Checking if the response status code indicates an error
                if let urlResponse = response as? HTTPURLResponse,
                   let error = HTTPNetworkError.errorBasedOnResponseCode(from: urlResponse.statusCode) {
                    completion(.failure(error))
                    return
                }
                
                guard let unwrappedData = data else {
                    completion(.failure(HTTPNetworkError.unknownError))
                    return
                }

                completion(.success(unwrappedData))
            }
        }
        
        task.resume()
    }
    
    func load(from url: URL, completion: @escaping HTTPResponseCompletionHandler) {
        let task = session.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(HTTPNetworkError.failed))
                    return
                }
                
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    func cancelRequest() {
        session.cancelRequest()
    }
}
