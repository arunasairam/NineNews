//
//  NetworkTests.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import XCTest
@testable import NineNews


/// This class tests the `Network`.
///
/// It has five tests:
///  - Test for successful API call
///  - Test for api call failure
///  - Test load from URL
///  - Test load from URL Failure
///  - Testing the data task cancellation

final class NetworkTests: XCTestCase {
    
    private var network: NineNetworkProtocol?
    private var mockURLSession: MockURLSession?
    
    override func setUpWithError() throws {
        mockURLSession = MockURLSession()
        
        guard let session = mockURLSession else { return }
        network = Network(session: session)
    }
    
    override func tearDownWithError() throws {
        mockURLSession = nil
        network = nil
    }
    
    
    /// Testing `makeAPICall(to: APIConfirmable)` success.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `data` should NOT be `nil`
    ///  - The completion block should return `success`
    
    func testMakeAPICallSuccess() throws {
        let expectation = XCTestExpectation(description: "`makeAPICall()` executed with completion")
        
        let testAPI = NewsAPI.getNewsList
        
        guard let mockURLSession = mockURLSession else {
            XCTFail("Not initialised")
            return
        }
        
        XCTAssertFalse(mockURLSession.dataTaskCalled, "Should false since dataTask is not called yet")
        
        
        mockURLSession.data = Data()
        mockURLSession.urlResponse = URLResponse()
        
        network?.makeAPICall(to: testAPI) { result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data, "Expected data to be non-nil")
                
            case .failure:
                XCTFail("Failure not expected")
            }
            
            XCTAssertTrue(mockURLSession.dataTaskCalled, "`datatask()`, which is in `MockURLSession` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    /// Testing `makeAPICall(to: APIConfirmable)` failure.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `error` should NOT be `nil`
    ///  - The completion block should return `failure`
    
    func testMakeAPICallFailure() throws {
        let expectation = XCTestExpectation(description: "`makeAPICall()` executed with completion")
        
        let testAPI = NewsAPI.getNewsList
        
        guard let mockURLSession = mockURLSession else {
            XCTFail("Not initialised")
            return
        }
        
        XCTAssertFalse(mockURLSession.dataTaskCalled, "Should false since dataTask is not called yet")
        
        mockURLSession.error = HTTPNetworkError.badRequest
        
        network?.makeAPICall(to: testAPI) { result in
            switch result {
            case .success:
                XCTFail("Success not expected")
                
            case let .failure(error):
                XCTAssertNotNil(error, "A valid error is expected")
            }
            
            XCTAssertTrue(mockURLSession.dataTaskCalled, "`datatask()`, which is in `MockURLSession` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    /// Testing `load(from: URL)` success
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `data` should NOT be `nil`
    ///  - The completion block should return `success`  
    
    func testLoadFromURLSuccess() throws {
        let expectation = XCTestExpectation(description: "`load(from: URL)` executed with completion")
        
        let testURL = URL(string: "https://www.fairfaxstatic.com.au/content/dam/images/h/2/9/a/u/c/image.related.wideLandscape.1500x844.p5ce72.13zzqx.png/1674200811398.jpg")!
        
        guard let mockURLSession = mockURLSession else {
            XCTFail("Not initialised")
            return
        }
        
        XCTAssertFalse(mockURLSession.dataTaskCalled, "Should false since dataTask is not called yet")
        
        mockURLSession.data = Data()
        mockURLSession.urlResponse = URLResponse()
        
        network?.load(from: testURL) { result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data)
                
            case .failure:
                XCTFail("Failure not expected")
            }
            
            XCTAssertTrue(mockURLSession.dataTaskCalled, "`datatask()`, which is in `MockURLSession` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    /// Testing `load(from: URL)` failure
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `error` should NOT be `nil`
    ///  - The completion block should return `failure`  
    
    func testLoadFromURLFailure() throws {
        let expectation = XCTestExpectation(description: "`load(from: URL)` executed with completion")
        
        let testURL = URL(string: "https://www.9news.com.au")!
        
        guard let mockURLSession = mockURLSession else {
            XCTFail("Not initialised")
            return
        }
        
        XCTAssertFalse(mockURLSession.dataTaskCalled, "Should false since dataTask is not called yet")
        
        mockURLSession.error = HTTPNetworkError.badRequest
        
        network?.load(from: testURL) { result in
            switch result {
            case .success:
                XCTFail("Success not expected")
                
            case let .failure(error):
                XCTAssertNotNil(error)
            }
            
            XCTAssertTrue(mockURLSession.dataTaskCalled, "`datatask()`, which is in `MockURLSession` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    /// Testing the data task cancellation
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `mockURLSession.cancelRequestCalled` should be `false` before calling `network?.cancelRequest()`
    ///  - `mockURLSession.cancelRequestCalled` should be `true` after calling `network?.cancelRequest()`
    
    func testCancelRequest() {
        guard let mockURLSession = mockURLSession else { return }
        
        XCTAssertFalse(mockURLSession.cancelRequestCalled, "The cancelRequestCalled should be false since cancelRequest() is not yet called")
        
        network?.cancelRequest()
        
        XCTAssertTrue(mockURLSession.cancelRequestCalled, "The cancelRequestCalled should be true at this stage")
    }
}
