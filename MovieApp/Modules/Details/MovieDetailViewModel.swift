//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by BobbyPhtr on 21/02/21.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel {
    
    var coordinator : Coordinator
    var movieApi : MovieService
    
    private let disposeBag = DisposeBag()
    
    let movieDetailPublishSubject = PublishSubject<MovieDetail>()
    
    // View Paramters
    let posterPublishSubject = BehaviorSubject<UIImage>(value: UIImage.init(named: "movie_placeholder")!)
    let titleLabelPublishSubject = BehaviorSubject<String>(value: "")
    let genreLabelPublishSubject = BehaviorSubject<String>(value: "")
    let runtimeLabelPublishSubject = BehaviorSubject<String>(value: "")
    let releaseDateLabelPublishSubject = BehaviorSubject<String>(value: "")
    
    let ratingLabelPublishSubject = BehaviorSubject<String>(value: "")
    let votersLabelPublishSubject = BehaviorSubject<String>(value: "")
    
    let overviewLabelPublishSubject = BehaviorSubject<String>(value: "")
    
    private let imagePosterUrl = BehaviorSubject<String>(value: "")
    
    init(movieId : Int, coordinator : Coordinator, movieService : MovieService) {
        self.coordinator = coordinator
        self.movieApi = movieService
        
        binding()
        
        getMovieDetails(movieId: movieId)
    }
    
    private func binding(){
        movieDetailPublishSubject.subscribe(onNext : {
            [unowned self] movieDetail in
            imagePosterUrl.onNext(movieDetail.posterPath)
            
            titleLabelPublishSubject.onNext(movieDetail.title)
            genreLabelPublishSubject.onNext(genresToString(genres: movieDetail.genres))
            runtimeLabelPublishSubject.onNext(movieDetail.runtime?.toTimeFormatAsMinutes() ?? "No Data")
            releaseDateLabelPublishSubject.onNext(movieDetail.releaseDate)
            
            ratingLabelPublishSubject.onNext(String(movieDetail.voteAverage))
            votersLabelPublishSubject.onNext(votersToString(voters: movieDetail.voteCount))
            
            overviewLabelPublishSubject.onNext(movieDetail.overview)
        }).disposed(by: disposeBag)
        
        imagePosterUrl.subscribe(onNext : {
            [unowned self] url in
            if url == "" {
                return
            }
            movieApi.getMoviePoster(imageUrl: url) { (image, error) in
                if let err = error {
                    coordinator.showDialog(title: "Maaf Terjadi Kesalahan", message: err.localizedDescription)
                } else {
                    posterPublishSubject.onNext(image!)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func getMovieDetails(movieId : Int){
        movieApi.getMovieDetail(movieId: movieId) { (response, err) in
            if let error = err {
                self.coordinator.showDialog(title: "Maaf Terjadi Kesalahan", message: error.localizedDescription)
            } else {
                self.movieDetailPublishSubject.onNext(response!)
            }
        }
    }

    
}

extension MovieDetailViewModel {
    fileprivate func genresToString(genres : [Genre])->String {
        return genres
            .map{ $0.name }
            .joined(separator: ", ")
    }
    
    fileprivate func votersToString(voters : Int) -> String {
        
        if voters > 1000 {
            let dec = Double(voters)/1000.0
            return String(format: "%.2fk voters", dec)
        }
        
        return "\(voters) voters"
    }
}
