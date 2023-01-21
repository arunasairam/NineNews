//
//  MockCacheService.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation
@testable import NineNews

final class MockCacheService: CacheServiceProvider {
    var storeDataCalled: Bool = false
    var retrieveDataCalled: Bool = false
    var data: Data?
    
    func store(_ data: AnyObject, forKey key: String) {
        storeDataCalled = true
    }

    func retrieveData(forKey key: String) -> AnyObject? {
        retrieveDataCalled = true
    
        return data as AnyObject
    }
}
