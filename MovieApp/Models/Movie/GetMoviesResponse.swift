//
//  GetMoviesResponse.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import Foundation

struct GetMovieResponse : Codable {
    let page : Int
    let results : [Movie]
    let totalPages : Int
    let totalResults : Int
    
    enum CodingKeys : String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
