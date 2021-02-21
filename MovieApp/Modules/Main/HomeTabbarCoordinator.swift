//
//  HomeTabbarCoordinator.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import Foundation
import UIKit
import SwiftIcons

protocol GeneralFlow : Flow {
    func goToMovieDetail(movieId : Int, navCon : UINavigationController)
}

class HomeTabbarCoordinator : Coordinator {
    
    weak var parentCoordinator : AppCoordinator!
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    let movieService = MovieServiceApi()
    
    init(navigationController : UINavigationController, parent : AppCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parent
    }
    
    func start() {
        
        let rootVC = UITabBarController.init()
        
        // Tabbar Configurations
        rootVC.tabBar.layer.masksToBounds = true
        rootVC.tabBar.barStyle = .black
        rootVC.tabBar.barTintColor = .black
        rootVC.tabBar.tintColor = UIColor.orange
        
        if rootVC.traitCollection.userInterfaceStyle == .light {
            rootVC.tabBar.barTintColor = .white
            rootVC.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
            rootVC.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            rootVC.tabBar.layer.shadowRadius = 10
            rootVC.tabBar.layer.shadowOpacity = 1
            
        }
        
        rootVC.tabBar.layer.masksToBounds = false
        
        // Home
        let homeNav = UINavigationController()
        homeNav.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        homeNav.tabBarItem = UITabBarItem(title: "Discover",
                                            image: UIImage.init(icon: .emoji(.movie), size: CGSize(width: 35, height: 35)),
                                            tag: 0)
        homeNav.navigationBar.tintColor = .orange
        
        let homeCoordinator = HomeCoordinator.init(navigationCon: homeNav, movieService: movieService)
        
        // Search
        let searchVm = SearchViewModel(coordinator: self, movieService: movieService)
        
        let searchVc = SearchViewController.init()
        searchVc.viewModel = searchVm
        
        let searchNav = UINavigationController(rootViewController: searchVc)
        searchNav.navigationBar.tintColor = .orange
        searchNav.tabBarItem = UITabBarItem(title: "Search",
                                            image: UIImage.init(icon: .emoji(.searchRight), size: CGSize(width: 35, height: 35)),
                                             tag: 1)
        searchNav.title = "Search"
        searchVm.navigationController = searchNav
        
        // Profile
        let profileVc = ProfileViewController.init()
        let profileNav = UINavigationController(rootViewController: profileVc)
        profileNav.tabBarItem = UITabBarItem(title: "Profile",
                                             image: UIImage.init(icon: .emoji(.user), size: CGSize(width: 35, height: 35)),
                                             tag: 2)
        profileNav.navigationBar.tintColor = .orange
        profileNav.title = "Profile"
        
        rootVC.viewControllers = [
            homeNav,
            searchNav,
            profileNav
            
        ]
        
        rootVC.modalPresentationStyle = .fullScreen
        navigationController.present(rootVC, animated: false, completion: nil)
        
        homeCoordinator.start()
        
    }
    
    
}

extension HomeTabbarCoordinator : GeneralFlow {
    
    func goToMovieDetail(movieId: Int, navCon : UINavigationController) {
        let movieDetailVC = MovieDetailViewController.init()
        
        movieDetailVC.viewModel = MovieDetailViewModel(movieId: movieId, coordinator: self, movieService: movieService)
        
        navCon.pushViewController(movieDetailVC, animated: true)
    }
    
    
}
