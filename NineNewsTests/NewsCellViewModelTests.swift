//
//  NewsCellViewModelTests.swift
//  NineNewsTests
//
//  Created by Aruna Sairam on 22/1/2023.
//

import XCTest
@testable import NineNews


/// This class tests the `NewsCellViewModel`.
///
/// It has four tests:
///  - Test loading image from the URL of the smallest image in the Asset's `relatedImages` array
///  - Test to check the failure to load the smallest when no images are found in the  Asset's `relatedImages` array
///  - Test to check the correctness of values in `article` property of `viewModel`
///  - Test to check the incorrectness of  values in `article` by adding a JSON file with wrong values
///
///  The MockJSON files have been supplied.

final class NewsCellViewModelTests: XCTestCase {

    private var viewModel: NewsCellViewModelProvider?
    private var imageManager: MockImageManager?
    
    override func setUpWithError() throws {
        guard let asset = loadDecodable(from: "mockJSONWithSingleAsset.json", ofType: Asset.self) else {
            XCTFail("Unable to load Asset")
            return
        }
        
        imageManager = MockImageManager()
        
        guard let imageManager = imageManager else {
            XCTFail("Not initialised")
            return
        }
        
        viewModel = NewsCellViewModel(article: asset, imageManager: imageManager)
    }
    
    override func tearDownWithError() throws {
        imageManager = nil
        viewModel = nil
    }
    
    
    /// Loads `.json` file and converts it to `Decodable`
    
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
    
    
    /// Testing loading image from the URL of the smallest image in the Asset's `relatedImages` array.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `error` should be `nil`
    ///  - The returned URL should of the URL of the smallest image in the `relatedAssets` array
    ///  - `imageManager.loadImageCalled` should be `true`
    ///  - `data` should NOT be `nil`
    ///  - `urlOfSmallestImage` should not be `nil`

    func testLoadSmallestImageFromAsset() throws {
        guard let imageManager = imageManager else {
            XCTFail("Not initialised")
            return
        }
        
        let expectation = XCTestExpectation(description: "Load image executed with completion")
        
        imageManager.data = Data()
        
        viewModel?.loadSmallestImageFromAsset() { data, urlOfSmallestImage, error in
            
            if let error = error {
                XCTFail("Error not expected : \(error.localizedDescription)")
            }
            
            XCTAssertTrue(imageManager.loadImageCalled, "Image manager's load image with cache is expected to be called")
            XCTAssertNotNil(data, "A valid data is expected")
            
            if let urlOfSmallestImage = urlOfSmallestImage {
                XCTAssertEqual(urlOfSmallestImage.absoluteString, "https://www.fairfaxstatic.com.au/content/dam/images/h/2/9/a/u/c/image.related.thumbnail.375x250.p5ce72.13zzqx.png/1674200811398.jpg", "The returned URL should of the URL of the smallest image in the `relatedAssets` array")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
    }
    
    
    /// Testing failure to load the smallest when no images are found in the  Asset's `relatedImages` array.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - `error` should NOT be `nil`
    ///  - The `error` should be equal to `AppError.foundNil`

    func testLoadSmallestImageFromAssetFailure() throws {
        let expectation = XCTestExpectation(description: "Load image executed with completion")
        
        guard let asset = loadDecodable(from: "mockJSONWithoutAnyImages.json", ofType: Asset.self) else {
            XCTFail("Unable to load Asset")
            return
        }
        
        viewModel?.article = asset
        
        viewModel?.loadSmallestImageFromAsset() { _, _, error in
            
            XCTAssertNotNil(error, "Error is expected")
            XCTAssertEqual(error as? AppError, AppError.foundNil)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    /// Testing the correctness of values in `article` property of `viewModel`.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - The comparison of the values of each asset should succeed

    func testArticleFromViewModel() throws {
       
        guard let viewModel = viewModel else {
            XCTFail("Not initialised")
            return
        }
        
        // Comparing the values in the first asset
        XCTAssertEqual(viewModel.article.assetType, AssetType.article)
        XCTAssertEqual(viewModel.article.id, 1520630750)
        XCTAssertEqual(viewModel.article.headline, "Wall Street insiders split on doom or Goldilocks outlook")
        XCTAssertEqual(viewModel.article.byLine, "Tony Boyd")
        XCTAssertEqual(viewModel.article.theAbstract, "Two leading strategists at Macquarie Securities and JP Morgan have opposite views about a US recession. One of them will be right.")
        XCTAssertEqual(viewModel.article.relatedImages?.count ?? 0, 6, "There should be 6 related images")
    }
    
    
    /// Testing incorrect  values in `article` by adding a JSON file with wrong values.
    ///
    /// For the test to pass the following conditions have to be fulfilled
    ///  - The comparison of the values of each asset should succeed

    func testWrongValuesInArticleInViewModel() throws {
        
        guard let article = loadDecodable(from: "mockJSONWithWrongValues.json", ofType: Asset.self) else {
            XCTFail("Unable to load Asset")
            return
        }
        
        viewModel?.article = article
        
        guard let viewModel = viewModel else {
            XCTFail("Not initialised")
            return
        }
        
        // Comparing the values in the first asset
        XCTAssertNotEqual(viewModel.article.assetType, AssetType.article)
        XCTAssertNotEqual(viewModel.article.id, 1520630750)
        XCTAssertNotEqual(viewModel.article.headline, "Wall Street insiders split on doom or Goldilocks outlook")
        XCTAssertNotEqual(viewModel.article.byLine, "Tony Boyd")
        XCTAssertNotEqual(viewModel.article.theAbstract, "Two leading strategists at Macquarie Securities and JP Morgan have opposite views about a US recession. One of them will be right.")
        XCTAssertNotEqual(viewModel.article.relatedImages?.count ?? 0, 6, "There should be 6 related images")
    }
}
