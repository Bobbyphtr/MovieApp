//
//  ShowAllViewController.swift
//  MovieApp
//
//  Created by BobbyPhtr on 21/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class ShowAllViewController: UIViewController {
    
    var viewModel : ShowAllViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var cellAreaInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    private lazy var collumnCount : CGFloat = 2
    private lazy var cellPadding : CGFloat = 8

    @IBOutlet weak var listCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.homeSection.rawValue
        
        listCollectionView.register(UINib(nibName: "ShowAllCell", bundle: .main), forCellWithReuseIdentifier: ShowAllCell.mReuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = cellPadding
        layout.minimumInteritemSpacing = cellPadding
        layout.sectionInset = cellAreaInset
        layout.scrollDirection = .vertical
        listCollectionView.collectionViewLayout = layout
        
        listCollectionView.delegate = self
        
        configureCollectionView()
        configureDatasource()
    }
    
    func configureCollectionView(){
        listCollectionView.rx.willDisplayCell
            .bind {
                _, indexpath in
                
                if indexpath.row == self.viewModel.moviesRelay.value.count - 1 {
                    self.viewModel.pageNumber += 1
                    self.viewModel.getMore()
                    self.listCollectionView.scrollToItem(at: indexpath, at: .top, animated: true)
                }
            }.disposed(by: disposeBag)
        
        listCollectionView.rx.modelSelected(Movie.self).bind {
            movie in
            self.viewModel.showMovieDetail(movieId: movie.id)
        }.disposed(by: disposeBag)
    }
    
    func configureDatasource(){
        listCollectionView.dataSource = nil
        viewModel.moviesRelay.bind(to: listCollectionView.rx.items) { (cv, row, element) in
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

extension ShowAllViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing = (cellAreaInset.left + cellAreaInset.right) + (cellPadding * collumnCount - 1)
        let width = floor((collectionView.frame.width - totalHorizontalSpacing)/collumnCount)
        return CGSize(width: width, height: width * 1.5)
    }
}
