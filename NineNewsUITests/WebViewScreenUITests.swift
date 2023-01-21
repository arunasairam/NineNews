//
//  WebViewScreenUITests.swift
//  NineNewsUITests
//
//  Created by Aruna Sairam on 23/1/2023.
//

import XCTest

/// This class tests Navigation and Website Screen.
///
/// It has three tests:
///  - Test to check if the app navigates to Web View screen upon tapping collection view cell
///  - Test to check if the Web View screen contains 'Progress bar', 'Refresh Button', 'Back Button', 'Share Button', 'Forward Button, 'Backward Button'
///  - Test to check if the app pops the view controller and comes back to home screen upon tapping the back button

class WebViewScreenUITests: XCTestCase {
    let app = XCUIApplication()
    
    private let collectionViewAccessibilityIdentifier = "newsListCollectionView"
    private let thumbnailAccessibilityIdentifier = "thumbnailImageView"
    private let webViewAccessibilityIdentifier = "newsWebView"
    private let webViewNavigationBarBackButton = "webViewNavigationBarBackButton"
    private let webPageProgressBarAccessibilityIdentifier = "webPageProgressBar"
    private let webPageRefreshButtonAccessibilityIdentifier = "webPageRefreshButton"
    private let webPageShareButtonAccessibilityIdentifier = "webPageShareButton"
    private let webPageNavigateForwardButtonAccessibilityIdentifier = "webPageNavigateForwardButton"
    private let webPageNavigateBackButtonAccessibilityIdentifier = "webPageNavigateBackButton"
    private let webViewNavigationBar = "webViewNavigationBar"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    /// Test to check if the app navigates to Web View screen upon tapping collection view cell
    
    func testCollectionViewExists() {
        
        // Verifying that the UIcollectionView is displayed correctly
        let collectionView = app.collectionViews["newsListCollectionView"]
        XCTAssertTrue(collectionView.exists)
        
        // Click on the first cell in the collection view
        let firstCell = collectionView.cells.element(boundBy: 0)
        firstCell.tap()
        
        // Verify that the app navigates to the next view controller containing a WKWebView
        let webView = app.webViews["newsWebView"]
        XCTAssertTrue(webView.exists)
    }
    
    
    /// Test to check if the Web View screen contains 'Progress bar', 'Refresh Button', 'Back Button', 'Share Button', 'Backward Button',  'Forward Button'.
    
    func testCheckProgressBarRefreshBackButtonShareBackwardForwardButtons() {
        
        // Verifying that the UIcollectionView is displayed correctly
        let collectionView = app.collectionViews["newsListCollectionView"]
        XCTAssertTrue(collectionView.exists)
        
        // Click on the first cell in the collection view
        let firstCell = collectionView.cells.element(boundBy: 0)
        firstCell.tap()
        
        // Verify that the app navigates to the next view controller containing a WKWebView
        let webView = app.webViews["newsWebView"]
        XCTAssertTrue(webView.exists)
        
        // Check if 'Progress bar' exists
        let progressBar = app.progressIndicators[webPageProgressBarAccessibilityIdentifier]
        XCTAssertTrue(progressBar.exists)
        
        // Check if 'Back' button exists on the navigationBar
        let navigationBackButton = app.navigationBars[webViewNavigationBar].buttons[webViewNavigationBarBackButton]
        XCTAssertTrue(navigationBackButton.exists)
        
        // Check if 'Refresh' button exists
        let refreshButton = app.buttons[webPageRefreshButtonAccessibilityIdentifier]
        XCTAssertTrue(refreshButton.exists)
        
        // Check if 'Share' button exists
        let shareButton = app.buttons[webPageShareButtonAccessibilityIdentifier]
        XCTAssertTrue(shareButton.exists)
        
        // Check if 'Navigate backward in Website' button exists
        let navigateBackwardButton = app.buttons[webPageNavigateBackButtonAccessibilityIdentifier]
        XCTAssertTrue(navigateBackwardButton.exists)
        
        // Check if 'Navigate forward in Website' button exists
        let navigateForwardButton = app.buttons[webPageNavigateForwardButtonAccessibilityIdentifier]
        XCTAssertTrue(navigateForwardButton.exists)
    }
    
    
    ///  Test to check if the app pops the view controller and comes back to home screen upon tapping the back button
    
    func testWebViewBackToHomeScreen() {
        
        // Verifying that the UIcollectionView is displayed correctly
        let collectionView = app.collectionViews["newsListCollectionView"]
        XCTAssertTrue(collectionView.exists)
        
        // Click on the first cell in the collection view
        let firstCell = collectionView.cells.element(boundBy: 0)
        firstCell.tap()
        
        // Verify that the app navigates to the next view controller containing a WKWebView
        let webView = app.webViews["newsWebView"]
        XCTAssertTrue(webView.exists)
        
        // Click on the back button to navigate back to the home screen
        app.navigationBars[webViewNavigationBar].buttons[webViewNavigationBarBackButton].tap()
        
        // Verifying that the UIcollectionView is displayed correctly
        XCTAssertTrue(collectionView.exists)
    }
}
