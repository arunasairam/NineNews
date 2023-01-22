//
//  WebViewModel.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import Foundation

protocol WebViewModelProvider {
    var mainURL: URL { get set }
    var shareableURL: URL { get set }
}

class WebViewModel: WebViewModelProvider {
    var mainURL: URL
    var shareableURL: URL
    
    init(url: URL) {
        self.mainURL = url
        self.shareableURL = url
    }
}
