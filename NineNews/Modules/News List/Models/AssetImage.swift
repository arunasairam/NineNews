//
//  AssetImage.swift
//  NineNews
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation

struct AssetImage: Decodable {
    let id: Int
    let brands: [String]?
    let url: URL?
    let relatedImageDescription: String?
    let photographer: String?
    let width, height: Int?
    let xLarge2X, xLarge, large2X, large: String?
    let thumbnail2X, thumbnail: String?
    let timeStamp: Int?
}
