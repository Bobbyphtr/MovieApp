//
//  ShowAllCell.swift
//  MovieApp
//
//  Created by BobbyPhtr on 21/02/21.
//

import UIKit

class ShowAllCell: UICollectionViewCell {

    static let mReuseIdentifier = "ShowAllCell"
    
    var movieId : Int?
    var movieYear : String? {
        didSet {
            if movieYear == nil || movieYear == "" {
                movieYear = "Unknown"
            } else{
                movieYear = movieYear?.substring(with: 0..<4)
            }
            
        }
    }
    var movieTitle : String?
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }
    
    func configureView(){
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 14
        posterImageView.layer.masksToBounds = true
        
        titleLabel.textColor = .orange
        titleLabel.text = movieTitle
        
        yearLabel.text = movieYear
    }

}
