//
//  AppError.swift
//  NineNews
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation

enum AppError: Error {
    case foundNil
    case notFound
    case unexpectedError
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .foundNil:
            return NSLocalizedString("Nil value", comment: "JSON Error")
        case .notFound:
            return NSLocalizedString("Not found", comment: "JSON Error")
        default:
            return NSLocalizedString("Unexpected Error", comment: "JSON Error")
        }
    }
}
