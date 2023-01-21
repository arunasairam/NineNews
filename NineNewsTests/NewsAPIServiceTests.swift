//
//  NewsAPIServiceTests.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import XCTest
@testable import NineNews


/// This class tests the `NewsAPIService`.
///
/// It has three tests
///  - Test for successful news fetching
///  - Test for fetching failure due to bad request
///  - Test for fetching failure due to internet connectivity issue

final class NewsAPIServiceTests: XCTestCase {

    private var service: NewsAPIServiceProvider?
    private var mockNetwork: MockNetwork?
    
    override func setUpWithError() throws {
        mockNetwork = MockNetwork()
        
        guard let mockNetwork = mockNetwork else { return }
        service = NewsAPIService(network: mockNetwork)
    }

    override func tearDownWithError() throws {
        mockNetwork = nil
        service = nil
    }
 
    
    /// Testing `fetchNews()` success
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `data` should NOT be `nil`
    ///  - The completion block should return `success`
    
    func testFetchNewsSuccess() throws {
        guard let mockNetwork = mockNetwork else {
            XCTFail("Not initialised")
            return
        }
                    
        XCTAssertFalse(mockNetwork.makeAPICalled, "Should be false since no call has been made yet")
        
        mockNetwork.data = Data()
                    
        let expectation = XCTestExpectation(description: "Fetch news executed with completion")
                    
        service?.fetchNews() { result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data, "Expected data to be non-nil")
        
            case .failure:
                XCTFail("Failure not expected")
            }
            
            XCTAssertTrue(mockNetwork.makeAPICalled, "`makeAPICall()`, which is in `MockNetwork` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    /// Testing `fetchNews()` failure due to bad request.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `error` should NOT be `nil`
    ///  - The error should be `HTTPNetworkError.badRequest`
    ///  - The completion block should return `failure`
    
    func testFetchNewsFailure() throws {
        guard let mockNetwork = mockNetwork else {
            XCTFail("Not initialised")
            return
        }
                    
        XCTAssertFalse(mockNetwork.makeAPICalled, "Should be false since no call has been made yet")
        
        let expectation = XCTestExpectation(description: "Fetch news executed with completion")
        
        mockNetwork.error = HTTPNetworkError.badRequest
        
        service?.fetchNews() { result in
            switch result {
            case .success:
                XCTFail("Success not expected")
                
            case let .failure(error):
                XCTAssertNotNil(error, "Expected Error to be non-nil")
                XCTAssertEqual(error as? HTTPNetworkError, HTTPNetworkError.badRequest)
            }
            
            XCTAssertTrue(mockNetwork.makeAPICalled, "`makeAPICall()`, which is in `MockNetwork` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    /// Testing `fetchNews()` failure due to internet connectivity issue
    ///
    /// For the test to pass the following conditions have to be fulfilled.
    ///  - `error` should NOT be `nil`.
    ///  - The `error` should be `HTTPNetworkError.networkError`
    ///  - The completion block should return `failure`

    func testFetchNewsFailureDueToInternetConnectivityIssue() throws {
        guard let mockNetwork = mockNetwork else {
            XCTFail("Not initialised")
            return
        }
                    
        XCTAssertFalse(mockNetwork.makeAPICalled, "Should be false since no call has been made yet")
        
        let expectation = XCTestExpectation(description: "Fetch news called")
        
        mockNetwork.error = HTTPNetworkError.networkError
        
        service?.fetchNews() { result in
            switch result {
            case .success:
                XCTFail("Success not expected")
                
            case let .failure(error):
                XCTAssertNotNil(error, "Expected Error to be non-nil")
                XCTAssertEqual(error as? HTTPNetworkError, HTTPNetworkError.networkError)
            }
            
            XCTAssertTrue(mockNetwork.makeAPICalled, "`makeAPICall()`, which is in `MockNetwork` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
