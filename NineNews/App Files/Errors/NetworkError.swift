//
//  HTTPErros.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

public enum HTTPNetworkError: Error {
    case unauthorized
    case badRequest
    case networkError
    case serverSideError
    case unknownError
    case failed
}

extension HTTPNetworkError: LocalizedError {
    
    static func errorBasedOnResponseCode(from statusCode: Int) -> HTTPNetworkError? {
        switch statusCode {
        case 200 ... 299: return nil
        case 401: return .unauthorized
        case 400 ... 499: return .badRequest
        case 500 ... 599: return .serverSideError
        default: return .unknownError
        }
    }
    
    private var prefix: String {
        return "Error:"
    }
    
    public var errorDescription: String? {
        switch self {
        case .networkError:
            return NSLocalizedString("\(prefix) Network Error", comment: "")
        case .unauthorized:
            return NSLocalizedString("\(prefix) Authorization error", comment: "")
        case .badRequest:
            return NSLocalizedString("\(prefix) Bad request", comment: "")
        case .serverSideError:
            return NSLocalizedString("\(prefix) Serverside Error", comment: "")
        case .unknownError:
            return NSLocalizedString("\(prefix) Unknown Error", comment: "")
        case .failed:
            return NSLocalizedString("\(prefix) Failed", comment: "")
        }
    }
}
