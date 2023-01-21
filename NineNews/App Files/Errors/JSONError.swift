//
//  JSONError.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

enum JSONError: Error {
    case encodingFailed
    case decodingFailed
    case unexpectedError
}

extension JSONError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return NSLocalizedString("Encoding failed", comment: "JSON Error")
        case .decodingFailed:
            return NSLocalizedString("Decoding failed", comment: "JSON Error")
        default:
            return NSLocalizedString("Unexpected Error", comment: "JSON Error")
        }
    }
}

