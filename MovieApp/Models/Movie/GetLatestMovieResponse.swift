//
//  GetLatestMovieResponse.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import Foundation

struct GetLatestMovieResponse : Codable{
    let adult : Bool
    let backdropPath : String?
    let genres : [Genre]
    let id : Int
    let title : String
    let overview : String
    let releaseDate : String
    let posterPath : String?
    
    enum CodingKeys : String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genres = "genres"
        case id = "id"
        case title = "title"
        case overview = "overview"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
