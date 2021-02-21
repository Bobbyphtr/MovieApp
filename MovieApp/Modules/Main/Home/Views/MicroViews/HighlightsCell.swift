//
//  HighlightsCell.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import UIKit

class HighlightsCell: UICollectionViewCell {
    
    var viewModel : Movie! {
        didSet {
            configureViews()
        }
    }
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var backdropImageView: UIImageView! {
        didSet {
            backdropImageView.contentMode = .scaleAspectFill
            backdropImageView.layer.cornerRadius = 8
            backdropImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var bg: UIView!
    
    static let mReuseIdentifier = "HighlightsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func configureViews(){
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.overview
    }
    

}
