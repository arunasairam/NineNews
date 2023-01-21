//
//  NineURLSession.swift
//  NineNews
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func cancelRequest()
}

class NineURLSession: URLSessionProtocol {
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask!
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        task = session.dataTask(with: request, completionHandler: completionHandler)
        return task
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        task = session.dataTask(with: url, completionHandler: completionHandler)
        return task
    }
    
    func cancelRequest() {
        if task != nil {
            task.cancel()
        }
    }
}
