//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import Foundation
import RxSwift
import RxCocoa

enum HomeSection : String, CaseIterable {
    case nowPlaying = "Now Playing"
    case popular = "Popular"
    case topRated = "Top Rated"
}

class HomeViewModel {
    
    var coordinator : HomeFlow!
    var movieService : MovieService!
    
    // Controllers Params
    var title : String = "Discover"
    
    // Contents
    let nowPlayingMoviesRelay = BehaviorRelay<[Movie]>(value: [])
    let topRatedMoviesRelay = BehaviorRelay<[Movie]>(value: [])
    let popularMoviesRelay = BehaviorRelay<[Movie]>(value: [])
    
    init(movieService : MovieService, coordinator : HomeFlow) {
        self.movieService = movieService
        self.coordinator = coordinator
        
        getNowPlayingMovies()
        getPopularMovies()
        getTopRated()
    }
    
    func genresString(genresID : [Int])->String{
        let genreStrings = genresID.map {  return movieService.genreIdToString(genreId: $0) ?? "" }
        return genreStrings.joined(separator: " ,")
    }
    
    private func getNowPlayingMovies(){
        movieService.getNowPlaying(page: 1) { [weak self] (response, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                self?.nowPlayingMoviesRelay.accept(response!.results)
            }
        }
    }
    
    private func getPopularMovies(){
        movieService.getPopular(page: 1) { [weak self] (response, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                self?.popularMoviesRelay.accept(response!.results)
            }
        }
    }
    
    private func getTopRated(){
        movieService.getTopRated(page: 1) { [weak self] (response, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                self?.topRatedMoviesRelay.accept(response!.results)
            }
        }
    }
    
    func getPosterImage(posterUrl : String?, onCompletion: @escaping (UIImage?)->Void){
        
        guard let url = posterUrl else {
            onCompletion(UIImage.init(named: "movie_placeholder")!)
            return
        }
        
        movieService.getMoviePoster(imageUrl: url) { (image, err) in
            if let error = err {
                self.coordinator?.showDialog(title: error.localizedDescription, message: "Maaf Terjadi Kesalahan")
                onCompletion(nil)
            } else {
                onCompletion(image)
            }
        }
    }
    
    func getBackdropImage(backdropUrl : String?, onCompletion: @escaping (UIImage?)->Void){
        
        guard let url = backdropUrl else {
            onCompletion(UIImage.init(named: "movie_placeholder")!)
            return
        }
        
        movieService.getMovieBackdrop(imageUrl: url) { (image, err) in
            if let error = err {
                self.coordinator?.showDialog(title: error.localizedDescription, message: "Maaf Terjadi Kesalahan")
                onCompletion(nil)
            } else {
                onCompletion(image)
            }
        }
    }
    
    func showMovieDetail(movieId : Int) {
        coordinator?.goToMovieDetail(movieId: movieId)
    }
    
    func showAllCategory(category : HomeSection) {
        coordinator?.goToCategory(category: category)
    }
}
