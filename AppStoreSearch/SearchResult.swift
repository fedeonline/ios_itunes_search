//
//  SearchResults.swift
//  AppStoreSearch
//
//  Created by Federico Pugnaloni on 05/02/2019.
//  Copyright © 2019 Federico Pugnaloni. All rights reserved.
//

import Foundation

class ResultArray:Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult:Codable, CustomStringConvertible {
    var description: String {
        return "Name: \(name), Artist Name: \(artistName)"
    }
    
    var artistName = ""
    var trackName = ""
    var name:String {
        return trackName
    }
    
}
