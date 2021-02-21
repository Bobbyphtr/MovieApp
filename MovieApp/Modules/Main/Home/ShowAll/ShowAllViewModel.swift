//
//  ShowAllViewModel.swift
//  MovieApp
//
//  Created by BobbyPhtr on 21/02/21.
//

import Foundation
import RxSwift
import RxCocoa


class ShowAllViewModel {
    
    var coordinator : HomeCoordinator!
    var movieApi : MovieService!
    
    var pageNumber = 1
    var homeSection : HomeSection!
    
    var moviesRelay = BehaviorRelay<[Movie]>(value: [])
    
    init(coordinator : HomeCoordinator, movieApi : MovieService, category : HomeSection) {
        self.coordinator = coordinator
        self.movieApi = movieApi
        self.homeSection = category
        
        getMore()
    }
    
    func getMore(){
        print(pageNumber)
        switch homeSection {
        case .nowPlaying:
            movieApi.getNowPlaying(page: pageNumber) { [unowned self] (response, err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    self.moviesRelay.accept(self.moviesRelay.value + response!.results)
                }
            }
            break
        case .popular:
            movieApi.getPopular(page : pageNumber) { [unowned self] (response, err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    self.moviesRelay.accept(self.moviesRelay.value + response!.results)
                }
            }
            break
        case .topRated:
            movieApi.getTopRated(page : pageNumber) { [unowned self] (response, err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    self.moviesRelay.accept(self.moviesRelay.value + response!.results)
                }
            }
            break
        default:
            break
        }
    }
        
    func getPosterImage(posterUrl : String?, onCompletion: @escaping (UIImage?)->Void){
        
        guard let url = posterUrl else {
            onCompletion(UIImage.init(named: "movie_placeholder")!)
            return
        }
        
        movieApi.getMoviePoster(imageUrl: url) { (image, err) in
            if let error = err {
                self.coordinator?.showDialog(title: error.localizedDescription, message: "Maaf Terjadi Kesalahan")
                onCompletion(nil)
            } else {
                onCompletion(image)
            }
        }
    }
    
    func showMovieDetail(movieId : Int){
        coordinator.goToMovieDetail(movieId: movieId)
    }
}
