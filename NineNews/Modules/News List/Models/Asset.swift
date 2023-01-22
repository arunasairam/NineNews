//
//  Asset.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

struct News: Decodable {
    let assets: [Asset]
    let assetType: AssetType?
}

struct Asset: Decodable {
    let id: Int
    let url: String?
    let lastModified: Int
    let sponsored: Bool
    let headline: String
    let theAbstract: String?
    let byLine: String?
    let numberOfComments: Int?
    let relatedAssets: [Asset]?
    let relatedImages: [AssetImage]?
    let assetType: AssetType?
    let timeStamp: Int?
    
    var date: Date? {
        let convertedDate = Date(timeIntervalSince1970: TimeInterval((timeStamp ?? 00) / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: dateFormatter.string(from: convertedDate))
    }
}

enum AssetType: Decodable, Equatable {
    case article
    case articleList
    case unknown(type: String?)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try? container.decode(String.self)
        
        switch value {
        case "ARTICLE":
            self = .article
            
        case "ASSET_LIST":
            self = .articleList
            
        default:
            self = .unknown(type: value)
        }
    }
}
