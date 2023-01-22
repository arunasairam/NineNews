//
//  ImageManagerTests.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import XCTest
@testable import NineNews


/// This class tests the `ImageManager`.
///
/// It has three tests:
///  - Test for loading image when there is no cache
///  - Test for loading image when the data is already cached
///  - Test for storing image data in cache after it is obtained from network

final class ImageManagerTests: XCTestCase {
    
    private var manager: ImageManagerProtocol?
    private var mockCacheService: MockCacheService?
    private var mockNetwork: MockNetwork?
    
    override func setUpWithError() throws {
        mockCacheService = MockCacheService()
        mockNetwork = MockNetwork()
        
        guard let mockNetwork = mockNetwork,
              let mockCacheService = mockCacheService else { return }
        
        manager = ImageManager(network: mockNetwork, cacheService: mockCacheService)
    }
    
    override func tearDownWithError() throws {
        mockCacheService = nil
        manager = nil
    }
    
    
    /// Testing if the image data is loaded from Network when the image is not cached yet.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `mockNetwork.loadFromURLCalled` should be `true`
    ///  - The completion block should return `success`
    ///  - `data` should NOT be `nil`
    
    func testLoadImageDataWhenThereIsNoCache() throws {
        guard let sampleImageURL = URL(string: "https://www.fairfaxstatic.com.au/content/dam/images/h/2/9/a/u/c/image.related.wideLandscape.1500x844.p5ce72.13zzqx.png/1674200811398.jpg") else {
            
            XCTFail("Invalid URL")
            return
        }
        
        guard let mockNetwork = mockNetwork else {
            XCTFail("Not initialised")
            return
        }
        
        let expectation = XCTestExpectation(description: "Load image executed with completion")
        
        XCTAssertFalse(mockNetwork.loadFromURLCalled, "Should be false since no call has been made yet")
        
        mockNetwork.data = Data()
        
        manager?.loadImageFromCacheOrNetwork(from: sampleImageURL) { result in
            switch result {
            case let .success(data):
                XCTAssertTrue(mockNetwork.loadFromURLCalled, "Since there is no cache, `loadFrom()`, which is in `Network` should be called")
                XCTAssertNotNil(data, "data should be non-nil since it is now fetched from the network")
                
            case .failure:
                XCTFail("Failure not expected")
            }
            
            XCTAssertTrue(mockNetwork.loadFromURLCalled, "`loadFrom(with: URL)`, which is in `MockNetwork` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    /// Testing if the image data is loaded from Cache when the image is already cached.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `mockNetwork.loadFromURLCalled` should be `false`
    ///  - The completion block should return `success`
    ///  - `data` should NOT be `nil`
    
    func testLoadImageDataWhenTheDataIsAlreadyCached() throws {
        guard let sampleImageURL = URL(string: "https://www.fairfaxstatic.com.au/content/dam/images/h/2/9/a/u/c/image.related.wideLandscape.1500x844.p5ce72.13zzqx.png/1674200811398.jpg") else {
            
            XCTFail("Invalid URL")
            return
        }
        
        guard let mockNetwork = mockNetwork else {
            XCTFail("Not initialised")
            return
        }
        
        let expectation = XCTestExpectation(description: "Load image executed with completion")
        
        XCTAssertFalse(mockNetwork.loadFromURLCalled, "Should be false since no call has been made yet")
        
        mockCacheService?.data = Data()
        
        manager?.loadImageFromCacheOrNetwork(from: sampleImageURL) { result in
            switch result {
            case let .success(data):
                XCTAssertFalse(mockNetwork.loadFromURLCalled, "Since there is already cache, `loadFrom(with: URL)`, which is in `MockNetwork` should NOT be called")
                XCTAssertNotNil(data, "data should be non-nil since it is fetched from cache")
                
            case .failure:
                XCTFail("Failure not expected")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    /// Testing if the image data is stored (cached) after obtaining from Network .
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `mockNetwork.loadFromURLCalled` should be `true`
    ///  - The completion block should return `success`  
    ///  - `data` should NOT be `nil`
    ///  - `mockCacheService.storeDataCalled` should be `true` after storing the data in cache
    
    func testImageDataStoreInCacheAfterObtaintainfromNetwork() throws {
        guard let sampleImageURL = URL(string: "https://www.fairfaxstatic.com.au/content/dam/images/h/2/9/a/u/c/image.related.wideLandscape.1500x844.p5ce72.13zzqx.png/1674200811398.jpg") else {
            
            XCTFail("Invalid URL")
            return
        }
        
        guard let mockNetwork = mockNetwork,
              let mockCacheService = mockCacheService else {
            XCTFail("Not initialised")
            return
        }
        
        let expectation = XCTestExpectation(description: "Load image executed with completion")
        
        XCTAssertFalse(mockNetwork.loadFromURLCalled, "Should be false since no call has been made yet")
        
        mockNetwork.data = Data()
        
        manager?.loadImageFromCacheOrNetwork(from: sampleImageURL) { result in
            switch result {
            case let .success(data):
                XCTAssertTrue(mockNetwork.loadFromURLCalled, "Since there is no cache, `loadFrom(with: URL)`, which is in `Network` should be called")
                XCTAssertTrue(mockCacheService.storeDataCalled, "Since the data is now obtained from network it should be stored in cache")
                XCTAssertNotNil(data, "data should be non-nil")
                
            case .failure:
                XCTFail("Failure not expected")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
