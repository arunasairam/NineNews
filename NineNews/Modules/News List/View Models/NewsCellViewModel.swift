//
//  NewsCellViewModel.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation
import UIKit

protocol NewsCellViewModelProvider {
    var article: Asset { get set }
    
    func loadSmallestImageFromAsset(completion: @escaping (Data?, URL?, Error?) -> Void)
}

class NewsCellViewModel: NewsCellViewModelProvider {
    var article: Asset
    
    private let imageManager: ImageManagerProtocol
    
    init(article: Asset,
         imageManager: ImageManagerProtocol = ImageManager()) {
        self.article = article
        self.imageManager = imageManager
    }
    
    func loadSmallestImageFromAsset(completion: @escaping (Data?, URL?, Error?) -> Void) {
        guard let urlOfsmallestImage = smallestImageAsset?.url else {
            completion(nil, nil, AppError.foundNil)
            return
        }
        
        imageManager.loadImageFromCacheOrNetwork(from: urlOfsmallestImage) { result in
            switch result {
            case let .success(data):
                completion(data, urlOfsmallestImage, nil)
                
            case let .failure(eror):
                completion(nil, urlOfsmallestImage, eror)
            }
        }
    }
    
    private var smallestImageAsset: AssetImage? {
        let smallestImage = article.relatedImages?.compactMap { (image) -> (AssetImage, Int)? in
            guard let width = image.width,
                  width != 0,
                  let height = image.height,
                  height != 0 else { return nil }
            
            guard let url = image.url,
                  url.pathExtension.lowercased() != "gif" else {
                return nil
            }
            
            return (image, width * height)
        }.sorted { $0.1 < $1.1 }.first?.0
        
        return smallestImage
    }
}
