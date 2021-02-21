//
//  MovieDetail.swift
//  MovieApp
//
//  Created by BobbyPhtr on 21/02/21.
//

import Foundation

struct MovieDetail : Codable {
    
    let posterPath : String
    let overview : String
    let genres : [Genre]
    let id : Int
    let title : String
    let releaseDate : String
    let voteAverage : Double
    let voteCount : Int
    let runtime : Int?
    
    enum CodingKeys : String, CodingKey {
        case posterPath = "poster_path"
        case overview = "overview"
        case genres = "genres"
        case id = "id"
        case title = "title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case runtime = "runtime"
    }
    
}
