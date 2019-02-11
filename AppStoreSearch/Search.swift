//
//  Search.swift
//  AppStoreSearch
//
//  Created by Federico Pugnaloni on 11/02/2019.
//  Copyright © 2019 Federico Pugnaloni. All rights reserved.
//

import Foundation

class Search {
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    enum Category: Int {
        case all = 0
        case music = 1
        case software = 2
        case ebooks = 3
        
        var type: String {
            switch self {
            case .music: return "musicTrack"
            case .software: return "software"
            case .ebooks:return "ebook"
            case .all: return ""
            }
        }
    }
    
    enum AnimationStyle {
        case slide
        case fade
    }
    
    private var dataTask: URLSessionDataTask? = nil
    private(set) var state: State = .notSearchedYet
    
    func performSearch(for text: String, category: Category, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            
            // cancel previous search
            dataTask?.cancel()
            state = .loading
                
            let url = iTunesURL(searchText: text, category: category)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                var success = false
                var newState = State.notSearchedYet
                
                // Was the search cancelled?
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    var searchResults = self.parse(data: data)
                    if searchResults.isEmpty {
                        newState = .noResults
                    } else {
                        searchResults.sort(by: <)
                        newState = .results(searchResults)
                    }
                    success = true
                }
                DispatchQueue.main.async {
                    // assign state in main thread to avoid race condition
                    self.state =  newState
                    completion(success)
                }
            })
            dataTask?.resume()
        }
    }
    
    // MARK: - Private Methods
    private func iTunesURL(searchText: String, category: Category) -> URL {
        let kind = category.type
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@", encodedText, kind)
        let url = URL(string: urlString)
        return url!
    }
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
}
