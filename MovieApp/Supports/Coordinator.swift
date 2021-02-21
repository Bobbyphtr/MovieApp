//
//  Coordinator.swift
//  MovieApp
//
//  Created by BobbyPhtr on 18/02/21.
//

import UIKit

protocol Coordinator : AnyObject, Flow {
    
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func childDidFinish(coordinator : Coordinator){
        for (index, child) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
            }
        }
    }
    
    func showDialog(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
}

protocol Flow {
    func showDialog(title : String, message : String)
}
