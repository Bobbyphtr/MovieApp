//
//  Colors.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import UIKit

extension UIColor {
    
    static func random()->UIColor  {
        return UIColor(
            red: CGFloat(arc4random()) / CGFloat(UInt32.max),
            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
            blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
            alpha: 1
        )
    }
    
}
