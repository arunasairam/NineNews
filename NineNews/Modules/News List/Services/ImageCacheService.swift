//
//  ImageCacheService.swift
//  NineNews
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation

protocol CacheServiceProvider {
    func store(_ data: AnyObject, forKey key: String)
    func retrieveData(forKey key: String) -> AnyObject?
}

class ImageCacheService: CacheServiceProvider {
    private static let cache = NSCache<NSString, AnyObject>()

    func store(_ data: AnyObject, forKey key: String) {
        Self.cache.setObject(data, forKey: key as NSString)
    }

    func retrieveData(forKey key: String) -> AnyObject? {
        Self.cache.object(forKey: key as NSString)
    }
}
