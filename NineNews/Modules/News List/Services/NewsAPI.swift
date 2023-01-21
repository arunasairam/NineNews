//
//  NewsAPI.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation
    
enum NewsAPI {
    case getNewsList
}

extension NewsAPI: APIConfirmable {
    var path: String {
        switch self {
        case .getNewsList:
            return "coding_test/13ZZQX/full"
        }
    }
    
    var method: HTTPRequestMethod {
        .get
    }
    
    var queryParameters: HTTPQueryParameters? { nil }
    
    var body: Data? { nil }
}
