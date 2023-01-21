//
//  APIConfirmable.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

public typealias HTTPQueryParameters = [String: Any?]
public typealias HTTPRequestHeaders = [String: Any]

protocol APIConfirmable {
    var path: String { get }
    var method: HTTPRequestMethod { get }
    var queryParameters: HTTPQueryParameters? { get }
    var body: Data? { get }
}

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"

    var value: String {
        rawValue
    }
}
