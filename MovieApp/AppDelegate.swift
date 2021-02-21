//
//  AppDelegate.swift
//  MovieApp
//
//  Created by BobbyPhtr on 18/02/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator : AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Start the app with Coordinator
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationCon = UINavigationController.init()
        appCoordinator = AppCoordinator(navCon: navigationCon)
        
        window!.rootViewController = navigationCon
        window!.makeKeyAndVisible()
        
        appCoordinator!.start()
        
        return true
    }


}

