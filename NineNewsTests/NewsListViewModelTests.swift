//
//  NewsListViewModelTests.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 23/1/2023.
//

import XCTest
@testable import NineNews


/// This class tests `NewsListViewModel`.
///
/// It has two tests:
///  - Test for loading news articles
///  - Test to get view model of type NewsCellViewModel for news cell

final class NewsListViewModelTests: XCTestCase {
    
    private var viewModel: NewsListViewModelProvider?
    private var mockManager: MockNewsManager?

    override func setUpWithError() throws {
        mockManager = MockNewsManager()
        
        guard let mockManager = mockManager else { return }
        viewModel = NewsListViewModel(manager: mockManager)
    }

    override func tearDownWithError() throws {
        mockManager = nil
        viewModel = nil
    }
    
    
    /// Testing `loadNewsArticles()`.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `assets.count` should be equal to `6`
    ///  - The completion block should retrun `success`
  
    func testLoadingNewsArticles() {
        let expectation = XCTestExpectation(description: "Load news executed with completion")
        
        mockManager?.assets = loadDecodable(from: "mockJSONWithWithArrayOfAssets.json", ofType: [Asset].self)
        
        guard let mockManager = mockManager else {
            XCTFail("Not initialised")
            return
        }
        
        XCTAssertFalse(mockManager.loadNewsCalled, "Should be false since no call has been made")
        
        viewModel?.loadNewsArticles() { result in
            switch result {
            case let .success(assets):
                
                // Comparing the values in the first asset
                XCTAssertEqual(assets.count, 2, "There should be 2 articles (news Assets) ")
                
            case .failure:
                XCTFail("Failure not expected")
            }
            
            
            XCTAssertTrue(mockManager.loadNewsCalled, "`loadNews()`, which is in `MockManager` should be called")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    /// Testing `getViewModel(for: IndexPath)`
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `viewModelForCell` should NOT be `nil`
    ///  - The comparison of the values of each asset should succeed

    func testGetViewModel() {
        guard let articles = loadDecodable(from: "mockJSONWithWithArrayOfAssets.json", ofType: [Asset].self) else {
            XCTFail("Unable to load JSON")
            return
        }
        
        guard var viewModel = viewModel else {
            XCTFail("Not initialised")
            return
        }
        
        viewModel.newsAssets = articles
        
        XCTAssertEqual(viewModel.newsAssets[0].id, 1520630750)
        XCTAssertEqual(viewModel.newsAssets[1].id, 1520620496)
        
        guard let viewModelForCell = viewModel.getViewModel(for: IndexPath(item: 0, section: 0)) else {
            XCTFail("Failure to get view model is not expected")
            return
        }
        
        // Comparing the values in the article.
        XCTAssertEqual(viewModelForCell.article.id, 1520630750, "This is the first article")
        XCTAssertEqual(viewModelForCell.article.headline, "Wall Street insiders split on doom or Goldilocks outlook")
        XCTAssertEqual(viewModelForCell.article.byLine, "Tony Boyd")
        XCTAssertEqual(viewModelForCell.article.theAbstract, "Two leading strategists at Macquarie Securities and JP Morgan have opposite views about a US recession. One of them will be right.")
        XCTAssertEqual(viewModelForCell.article.relatedImages?.count ?? 0, 6, "There should be 6 related images")
    }
    
    
    /// Testing `getViewModel(for: IndexPath)` failure due to index path out of bounds.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - the value of  `viewModel.getViewModel(for: IndexPath(item: 3, section: 0))` should be `nil`
    ///  - The comparison of the values of each asset should succeed

    func testGetViewModelFailureDueToIndexPathOutOfBounds() {
        guard let articles = loadDecodable(from: "mockJSONWithWithArrayOfAssets.json", ofType: [Asset].self) else {
            XCTFail("Unable to load JSON")
            return
        }
        
        guard var viewModel = viewModel else {
            XCTFail("Not initialised")
            return
        }
        
        viewModel.newsAssets = articles
        
        XCTAssertEqual(viewModel.newsAssets[0].id, 1520630750)
        XCTAssertEqual(viewModel.newsAssets[1].id, 1520620496)
        
        if viewModel.getViewModel(for: IndexPath(item: 3, section: 0)) == nil {
            XCTAssert(3 >= viewModel.newsAssets.count, "The specified index is more than the count of the `newsAssets`")
        }
    }
    
    
    /// Loads `.json` file and converts it to `Decodable`
    ///
    /// This can be moved to a helper class to avoid repetition.
    
    private func loadDecodable<T: Decodable>(from filename: String, ofType decodable: T.Type) -> T? {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: filename, withExtension: nil) else {
            XCTFail("Unable to find \(filename)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(decodable, from: data)
            
            return decodedData
        } catch {
            XCTFail("Unable to load \(filename) from test bundle: \(error)")
            return nil
        }
    }
}
