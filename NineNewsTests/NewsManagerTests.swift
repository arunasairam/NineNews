//
//  NewsManagerTests.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import XCTest
@testable import NineNews


/// This class tests the `NewsManager`.
///
/// It has two tests:
///  - Test for successful news loading with the data decoded as expected
///  - Test for loading failure due decoding error
///
/// The MockJSON files have been supplied to the mockService.

final class NewsManagerTests: XCTestCase {
    
    private var manager: NewsManagerProtocol?
    private var mockService: MockNewsAPIService?
    
    override func setUpWithError() throws {
        mockService = MockNewsAPIService()
        
        guard let service = mockService else { return }
        manager = NewsManager(service: service)
    }

    override func tearDownWithError() throws {
        mockService = nil
        manager = nil
    }
    
    
    /// Testing `loadNews()` success with the data from the service decoded as expected
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///
    ///  - `assets.count` should be equal to `2`
    ///  - The completion block should retrun `success`
    ///  - The comparison of the values of each asset should succeed
    
    func testLoadNewsSuccess() throws {
        let expectation = XCTestExpectation(description: "Load news executed with completion")
        
        let data = loadMockJSON(filename: "mockJSONWithValidData.json")
        
        guard let data = data else {
            XCTFail("Unable to load data from mockJSON")
            return
        }
        
        guard let mockService = mockService else {
            XCTFail("Not initialised")
            return
        }
        
        XCTAssertFalse(mockService.fetchNewsCalled, "Should false since no call has been made yet")
        
        mockService.data = data
        
        manager?.loadNews() { result in
            switch result {
            case let .success(assets):
                
                // Comapring the number of assets
                XCTAssertEqual(assets.count, 2, "The mock json contains only two assets")
                
                // Comparing the values in the first asset
                XCTAssertEqual(assets[0].assetType, AssetType.article)
                XCTAssertEqual(assets[0].id, 1520630750)
                XCTAssertEqual(assets[0].headline, "Wall Street insiders split on doom or Goldilocks outlook")
                XCTAssertEqual(assets[0].byLine, "Tony Boyd")
                XCTAssertEqual(assets[0].theAbstract, "Two leading strategists at Macquarie Securities and JP Morgan have opposite views about a US recession. One of them will be right.")
                XCTAssertEqual(assets[0].relatedImages?.count ?? 0, 6, "There should be 6 related images in the first asset")
                
                // Comparing the values in the second asset
                XCTAssertEqual(assets[1].assetType, AssetType.article)
                XCTAssertEqual(assets[1].id, 1520620496)
                XCTAssertEqual(assets[1].headline, "How wealthy are you compared to everyone else (in eight charts)?")
                XCTAssertEqual(assets[1].byLine, "Michael Read")
                XCTAssertEqual(assets[1].theAbstract, "Does an income over $180,000 make you rich? That is one of the key questions posed in the debate around the future of stage three tax cuts.")
                XCTAssertEqual(assets[1].relatedImages?.count ?? 0, 5, "There should be 5 related images in the second asset")
                
            case .failure:
                XCTFail("Failure not expected")
            }
            
            XCTAssertTrue(mockService.fetchNewsCalled, "`fetchNews(), which is in `NewsAPIService` Should called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
    }
    
    
    /// Testing `loadNews()` failure
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `error` should NOT be `nil`.
    ///  - `error` should be `JSONError.decodingFailed`
    ///  - The completion block should return `failure`
    ///  - The comparison of the values of each asset should succeed
    
    func testLoadNewsFailure() throws {
        let expectation = XCTestExpectation(description: "Load news executed with completion")
        
        let data = loadMockJSON(filename: "mockJSONWithInvalidJSONFormat.json")
        
        guard let data = data else {
            XCTFail("Unable to load data from mockJSON")
            return
        }
        
        guard let mockService = mockService else {
            XCTFail("Not initialised")
            return
        }
        
        XCTAssertFalse(mockService.fetchNewsCalled, "Should false since no call has been made yet")
        
        mockService.data = data
        
        manager?.loadNews() { result in
            switch result {
            case .success:
                XCTFail("Failure not expected")
                
            case let .failure(error):
                XCTAssertEqual(error as? JSONError, JSONError.decodingFailed)
            }
            
            XCTAssertTrue(mockService.fetchNewsCalled, "`fetchNews(), which is in `NewsAPIService` Should called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    /// Loads `.json` file and converts it to `Data`
    
    private func loadMockJSON(filename: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: filename, withExtension: nil) else {
            XCTFail("Unable to find \(filename)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            XCTFail("Unable to load \(filename) from test bundle: \(error)")
            return nil
        }
    }
}
