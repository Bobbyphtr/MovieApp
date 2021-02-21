//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by BobbyPhtr on 21/02/21.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    var coordinator : GeneralFlow!
    var movieService : MovieService!
    weak var navigationController : UINavigationController!
    
    private let disposeBag = DisposeBag()
    
    var moviesRelay = BehaviorRelay<[Movie]>(value: [])
    let searchText = PublishSubject<String>()
    let isLoading = PublishSubject<Bool>()
    
    var currentKeyword : String = ""
    
    var pageNumber = 1
    var isSearch : Bool = false
   
    init(coordinator : GeneralFlow, movieService : MovieService) {
        self.coordinator = coordinator
        self.movieService = movieService
        
        setupBinding()
        doSearch(keyword: "")
        
        searchText.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
    
    private func setupBinding(){
        searchText
//            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext : {
            text in
            self.doSearch(keyword: text)
        }).disposed(by: disposeBag)
    }
    
    private func doSearch(keyword : String) {
        print(keyword)
        currentKeyword = keyword
        isLoading.onNext(true)
        if keyword == "" {
           isSearch = false
           pageNumber = 1
           movieService.getPopular(page : pageNumber) { [unowned self] (response, err) in
               if let error = err {
                   print(error.localizedDescription)
               } else {
                   self.moviesRelay.accept(response!.results)
               }
            self.isLoading.onNext(false)
           }
       } else {
           isSearch = true
           pageNumber = 1
           movieService.searchMovie(keyword: keyword, page: pageNumber) { (response, err) in
               if let error = err {
                   self.coordinator.showDialog(title: "Maaf Terjadi Kesalahan", message: error.localizedDescription)
               } else {
                   self.moviesRelay.accept(response!.results)
               }
            self.isLoading.onNext(false)
           }
       }
    }
    
    func loadMore(){
        if isSearch {
            movieService.searchMovie(keyword: currentKeyword, page: pageNumber) { (response, err) in
                if let error = err {
                    self.coordinator.showDialog(title: "Maaf Terjadi Kesalahan", message: error.localizedDescription)
                } else {
                    self.moviesRelay.accept(self.moviesRelay.value + response!.results)
                }
            }
        } else {
            movieService.getPopular(page : pageNumber) { [unowned self] (response, err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    self.moviesRelay.accept(self.moviesRelay.value + response!.results)
                }
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
    
    func showMovieDetail(movieId : Int){
        coordinator.goToMovieDetail(movieId: movieId, navCon: navigationController)
    }
    
}
