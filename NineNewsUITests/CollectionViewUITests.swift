//
//  CollectionViewUITests.swift
//  NineNewsUITests
//
//  Created by Aruna Sairam on 23/1/2023.
//

import XCTest
@testable import NineNews


/// This class tests the  CollectionView and the UI elements in the CollectionViewCell.
///
/// It has eight tests:
///  - Test to check if the collectionView exists
///  - Test to that the collection view is displayed correctly with multiple cells.
///  - Test to check if the collection view cell contiains the 'Thumbnail' image.
///  - Test to check 'Headline' in CollectionViewCell
///  - Test to check 'By Line' text in CollectionViewCell
///  - Test to check 'Abstract' in CollectionViewCell
///  - Test to check 'Time Elapsed' text in CollectionViewCell
///  - Test to check 'Nine News' logo in the Home Page


final class CollectionViewTests: XCTestCase {
    let app = XCUIApplication()
    
    private let collectionViewAccessibilityIdentifier = "newsListCollectionView"
    private let thumbnailAccessibilityIdentifier = "thumbnailImageView"
    private let headlineAccessibilityIdentifier = "headline"
    private let byLineAccessibilityIdentifier = "byLine"
    private let abstractAccessibilityIdentifier = "abstract"
    private let timeElapsedAccessibilityIdentifier = "timeElapsed"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /// Test to check if the collection view exists and is displayed.
    
    func testCollectionViewExists() {
        let collectionView = app.collectionViews[collectionViewAccessibilityIdentifier]
        XCTAssertTrue(collectionView.exists, "Collection view should exist")
    }
    
    
    /// Test to check that the collection view is displayed correctly with multiple cells.
    
    func testCollectionViewHasMultipleCells() {
      let collectionView = app.collectionViews[collectionViewAccessibilityIdentifier]
      XCTAssertTrue(collectionView.exists)
      XCTAssertTrue(collectionView.cells.count > 1, "Collection view should have multiple cells")
    }
    
    
    /// Test to check if the collection view cell contiains the 'Thumbnail' image.
    
    func testCollectionViewDisplaysThumbnailImage() {
        let collectionView = app.collectionViews[collectionViewAccessibilityIdentifier]
        XCTAssertTrue(collectionView.exists, "Collection view should exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.images[thumbnailAccessibilityIdentifier].exists, "First cell should have a thumbnail image")
    }
    
    
    /// Test to check 'Headline' in CollectionViewCell
    
    func testCollectionViewDisplaysHeadline() {
        let collectionView = app.collectionViews[collectionViewAccessibilityIdentifier]
        XCTAssertTrue(collectionView.exists, "Collection view should exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts[headlineAccessibilityIdentifier].exists, "First cell should have headline")
    }
    
    
    /// Test to check 'By Line' text in CollectionViewCell
    
    func testCollectionViewDisplaysByLine() {
        let collectionView = app.collectionViews[collectionViewAccessibilityIdentifier]
        XCTAssertTrue(collectionView.exists, "Collection view should exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts[byLineAccessibilityIdentifier].exists, "First cell should have 'by line'")
    }
    
    
    /// Test to check 'Abstract' in CollectionViewCell
    
    func testCollectionViewDisplaysAbstract() {
        let collectionView = app.collectionViews[collectionViewAccessibilityIdentifier]
        XCTAssertTrue(collectionView.exists, "Collection view should exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts[abstractAccessibilityIdentifier].exists, "First cell should have abstract")
    }
    
    
    /// Test to check 'Time Elapsed' text in CollectionViewCell
    
    func testCollectionViewDisplaysTimeElapsed() {
        let collectionView = app.collectionViews[collectionViewAccessibilityIdentifier]
        XCTAssertTrue(collectionView.exists, "Collection view should exist")
        
        let firstCell = collectionView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.staticTexts[timeElapsedAccessibilityIdentifier].exists, "First cell should have 'time elapsed' label")
    }
    
    
    /// Test to check 'Nine News' logo in the Home Page
    
    func testNineNewsLogoOnTheNavigationBar() {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "NineNewsLogo")
        
        let expectedImage = UIImage(named: "NineNewsLogo")
        XCTAssertEqual(logoImageView.image, expectedImage, "Should have the correct Nine News logo image")
    }
}
