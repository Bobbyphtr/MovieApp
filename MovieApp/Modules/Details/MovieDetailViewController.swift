//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController {
    
    var viewModel : MovieDetailViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var detailScrollView: UIScrollView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieMetaStackView: UIStackView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var votersCountLabel: UILabel!
    
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure View
        configureView()
        // Bind Views
        bindViews()
    }
    
    private func configureView(){
        
        // Scroll View
        detailScrollView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //stack view
        movieMetaStackView.setCustomSpacing(8, after: movieGenreLabel)
        
    }
    
    private func bindViews() {
        
        viewModel.titleLabelPublishSubject.subscribe(onNext : {
            string in
            print(string)
        }).disposed(by: disposeBag)
        
        viewModel.posterPublishSubject.bind(to: posterImageView.rx.image).disposed(by: disposeBag)
        
        viewModel.titleLabelPublishSubject.bind(to: movieTitleLabel.rx.text).disposed(by: disposeBag)
        viewModel.titleLabelPublishSubject.bind(to: rx.title).disposed(by: disposeBag)
        
        viewModel.genreLabelPublishSubject.bind(to: movieGenreLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.runtimeLabelPublishSubject.bind(to: movieDuration.rx.text).disposed(by: disposeBag)
        
        viewModel.releaseDateLabelPublishSubject.bind(to: movieReleaseDate.rx.text).disposed(by: disposeBag)
        
        viewModel.ratingLabelPublishSubject.bind(to: movieRatingLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.votersLabelPublishSubject.bind(to: votersCountLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.overviewLabelPublishSubject.bind(to: movieOverview.rx.text).disposed(by: disposeBag)
    }

}

extension MovieDetailViewController : UIScrollViewDelegate {
    
}
