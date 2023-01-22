//
//  ImageLoader.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import Foundation

protocol ImageManagerProtocol {
    func loadImageFromCacheOrNetwork(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class ImageManager: ImageManagerProtocol {
    private let network: NineNetworkProtocol
    private let cacheService: CacheServiceProvider
    
    init(network: NineNetworkProtocol = Network(),
         cacheService: CacheServiceProvider = ImageCacheService()) {
        self.network = network
        self.cacheService = cacheService
    }

    func loadImageFromCacheOrNetwork(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
       
        // Cancel previous requests
        cancelImageLoad()
        
        // Fetching cached image if present
        if let imageDataFromCache = cacheService.retrieveData(forKey: url.absoluteString) as? Data {
            completion(.success(imageDataFromCache))
            return
        }
        
        network.load(from: url) { [weak self] result in
            switch result {
            case let .success(data):
                // Cache the image data
                self?.cacheService.store(data as AnyObject, forKey: url.absoluteString)
                
                completion(.success(data))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cancelImageLoad() {
        network.cancelRequest()
    }
    
    deinit {
        cancelImageLoad()
    }
}

