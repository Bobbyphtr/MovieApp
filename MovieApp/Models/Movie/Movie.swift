//
//  Movie.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import Foundation

struct Movie : Codable {
    let backdropPath : String?
    let adult : Bool
    let overview : String
    let releaseDate : String
    let genreIDs : [Int]
    let id : Int
    let title : String
    let posterPath : String?
    
    enum CodingKeys : String, CodingKey {
        case backdropPath = "backdrop_path"
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case id = "id"
        case title = "title"
        case posterPath = "poster_path"
    }
}
