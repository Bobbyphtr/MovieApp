//
//  SectionHeader.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let mReuseIdentifier = "SectionHeader"

    var homeSection : HomeSection! {
        didSet {
            categoryTitle.text = homeSection.rawValue
        }
    }
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    
    var onSeeAllTapped : ((HomeSection)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onSeeAllTapped(_ sender: Any) {
        onSeeAllTapped?(homeSection)
    }
    
    
}
