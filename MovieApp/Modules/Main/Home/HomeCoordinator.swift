//
//  HomeCoordinator.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import Foundation
import UIKit

protocol HomeFlow : AnyObject, Flow {
    func goToHome()
    func goToMovieDetail(movieId : Int)
    func goToCategory(category : HomeSection)
}

class HomeCoordinator : Coordinator {
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    // MARK: SERVICES
    var movieService : MovieService!
    
    init(navigationCon : UINavigationController, movieService : MovieService) {
        self.navigationController = navigationCon
        self.movieService = movieService
    }
    
    func start() {
        goToHome()
//        navigationController.title = "Discover"
    }
    
    deinit {
        print("Home Coordinator Deinit")
    }
    
}

extension HomeCoordinator : HomeFlow {
    
    func goToCategory(category: HomeSection) {
        let vm = ShowAllViewModel.init(coordinator: self, movieApi: movieService, category: category)
        
        let vc = ShowAllViewController()
        vc.viewModel = vm
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func goToHome() {
        let homeVM = HomeViewModel.init(movieService: movieService, coordinator: self)
        
        let homeViewController = HomeViewController()
        homeViewController.vm = homeVM
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func goToMovieDetail(movieId : Int) {
        let movieDetailVC = MovieDetailViewController.init()
        
        movieDetailVC.viewModel = MovieDetailViewModel(movieId: movieId, coordinator: self, movieService: movieService)
        
        navigationController.pushViewController(movieDetailVC, animated: true)
    }
    
}


