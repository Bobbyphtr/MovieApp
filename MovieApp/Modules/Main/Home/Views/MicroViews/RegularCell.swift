//
//  RegularCell.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import UIKit

class RegularCell: UICollectionViewCell {
    
    static let mReuseIdentifier = "RegularCell"
    
    var movieId : Int? {
        didSet {
            configureView()
        }
    }

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(){
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.masksToBounds = true
    }

}
