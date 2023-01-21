//
//  Environment.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation

struct Enviroment {
    static var baseURL: URL? {
        return URL(string: "https://\(apiHostName)/\(apiVersion)/")
    }
    
    static var apiHostName: String {
        // We can specify different host name for different flags if needed
        return "bruce-v2-mob.fairfaxmedia.com.au"
    }
    
    static var apiVersion: String {
        return "1"
    }
}
