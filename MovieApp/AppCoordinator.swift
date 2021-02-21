//
//  AppCoordinator.swift
//  MovieApp
//
//  Created by BobbyPhtr on 18/02/21.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navCon : UINavigationController) {
        self.navigationController = navCon
    }
    
    func start() {
        print("App Coordinator Start")
        // Need to check if user already login or this is a first time launch.
        goToHome()
    }
    
    deinit {
        print("App Coordinator Finish")
    }
    
    func goToHome(){
        let homeTabbarCoordinator = HomeTabbarCoordinator(navigationController: navigationController, parent: self)
        children.append(homeTabbarCoordinator)
        homeTabbarCoordinator.start()
    }
}
