//
//  SearchViewController.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UISearchBarDelegate {

    var viewModel : SearchViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    private let searchBarController = UISearchController()
    
    private lazy var cellAreaInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private lazy var collumnCount : CGFloat = 2
    private lazy var cellPadding : CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false

        searchBarController.searchBar.placeholder = "What movie are you looking for?"
        navigationItem.searchController = searchBarController
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = cellPadding
        layout.minimumInteritemSpacing = cellPadding
        layout.sectionInset = cellAreaInset
        layout.scrollDirection = .vertical
        searchCollectionView.collectionViewLayout = layout
        searchCollectionView.delegate = self
        
        
        searchCollectionView.register(UINib(nibName: "ShowAllCell", bundle: .main), forCellWithReuseIdentifier: ShowAllCell.mReuseIdentifier)
        
        configureDatasource()
        configureCollectionView()
        configureSearchBindings()
    }
    
    func configureSearchBindings(){
        searchBarController.searchBar.rx.setDelegate(self).disposed(by: disposeBag)
        
        searchBarController.searchBar.rx.searchButtonClicked.bind {
            self.viewModel.searchText.onNext(self.searchBarController.searchBar.text ?? "")
        }.disposed(by: disposeBag)
        
        searchBarController.searchBar.rx.text
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext : { text in
                if text == "" || text == nil {
                    self.viewModel.isLoading.onNext(false)
                } else {
                    self.viewModel.isLoading.onNext(true)
                }
        }).disposed(by: disposeBag)
    }
    
    func configureCollectionView(){
        viewModel.isLoading.map{ $0 ? 0 : 1.0 }
            .subscribe(onNext :{ alpha in
                UIView.animate(withDuration: 0.25) {
                    self.searchCollectionView.alpha = alpha
                }
            }).disposed(by: disposeBag)
        
        searchCollectionView.rx.willDisplayCell
            .bind {
                _, indexpath in
                
                if indexpath.row == self.viewModel.moviesRelay.value.count - 1 {
                    self.viewModel.pageNumber += 1
                    self.viewModel.loadMore()
                    self.searchCollectionView.scrollToItem(at: indexpath, at: .top, animated: true)
                }
            }.disposed(by: disposeBag)
        
        searchCollectionView.rx.modelSelected(Movie.self).bind {
            movie in
            self.viewModel.showMovieDetail(movieId: movie.id)
        }.disposed(by: disposeBag)
    }
    
    func configureDatasource(){
        searchCollectionView.dataSource = nil
        viewModel.moviesRelay.bind(to: searchCollectionView.rx.items) { (cv, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = cv.dequeueReusableCell(withReuseIdentifier: ShowAllCell.mReuseIdentifier, for: indexPath) as! ShowAllCell
            self.viewModel.getPosterImage(posterUrl: element.posterPath, onCompletion: { (image) in
                cell.posterImageView.image = image
            })
            cell.movieTitle = element.title
            cell.movieYear = element.releaseDate
            return cell
        }.disposed(by: disposeBag)
    }

}

extension SearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing = (cellAreaInset.left + cellAreaInset.right) + (cellPadding * collumnCount - 1)
        let width = floor((collectionView.frame.width - totalHorizontalSpacing)/collumnCount)
        return CGSize(width: width, height: width * 1.5)
    }
}
