//
//  HomeTableCell.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeCell: UICollectionViewCell {
    
    static let mReuseIdentifier = "RegularSection"
    
    var viewModel : HomeViewModel?
    var currentSection : HomeSection? {
        didSet {
            configureCV()
        }
    }
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var cv: UICollectionView!
    
    private var collumnCount = 1
    private var cellSpacing : CGFloat = 8
    private var peekWidth : CGFloat = 8
    private lazy var itemWidth : CGFloat = max(CGFloat(0), (cv.frame.size.width*0.667) - CGFloat(2 * (cellSpacing + peekWidth)))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cv.register(UINib(nibName: "RegularCell", bundle: .main), forCellWithReuseIdentifier : RegularCell.mReuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let leftRightInset : CGFloat = cellSpacing + peekWidth
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        layout.minimumInteritemSpacing = 0
        cv.collectionViewLayout = layout
        cv.delegate = self
    }
    
    func configureCV(){
        cv.dataSource = nil
        switch currentSection {
        case .topRated:
            viewModel?.topRatedMoviesRelay.bind(to: cv.rx.items) { cv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = cv.dequeueReusableCell(withReuseIdentifier: RegularCell.mReuseIdentifier, for: indexPath) as! RegularCell
                self.viewModel?.getPosterImage(posterUrl: element.posterPath, onCompletion: { (image) in
                    cell.posterImageView.image = image
                    cell.movieId = element.id
                })
                return cell
            }.disposed(by: disposeBag)
            
            cv.rx.modelSelected(Movie.self).bind { model in
                self.viewModel?.showMovieDetail(movieId: model.id)
            }.disposed(by: disposeBag)
            
            break
        case .popular:
            viewModel?.popularMoviesRelay.bind(to: cv.rx.items) { cv, row, element in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = cv.dequeueReusableCell(withReuseIdentifier: RegularCell.mReuseIdentifier, for: indexPath) as! RegularCell
                self.viewModel?.getPosterImage(posterUrl: element.posterPath, onCompletion: { (image) in
                    cell.posterImageView.image = image
                    cell.movieId = element.id
                })
                return cell
            }.disposed(by: disposeBag)
            
            cv.rx.modelSelected(Movie.self).bind {
                model in
                self.viewModel?.showMovieDetail(movieId: model.id)
            }.disposed(by: disposeBag)
            
            break
        default :
            break
        }
    }
    
    /// Letak scrollview sekarang
    private var currentOffset : CGPoint?
    /// Seberapa besar scroll hingga scrollview bergerak  ke index selanjutnya
    private var scrollThreshold : CGFloat = 0.8
    
}

extension HomeCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth * 0.6667, height: collectionView.frame.height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffset = scrollView.contentOffset
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let currOffset = currentOffset else { return }
        // target dimana scroll view akan berhenti terdrag
        let target = targetContentOffset.pointee
        // jarak  user dari tempat pencet sampai ke target destinasi
        let distance = target.x - currOffset.x
        // Memastikan koefisien diantara 0 - 1
        let coefficent = Int(max(-1, min(distance/scrollThreshold, 1)))
        // Mendapatkan index item sekarang
        let currentIndex = Int(round(currOffset.x / itemWidth))
        
        let adjacentItemIndex = currentIndex + coefficent
        let adjacentItemIndexFloat = CGFloat(adjacentItemIndex)
        // Mendapatkan letak pergeseran untuk objek selanjutnya.
        let adjacentItemOffsetX = adjacentItemIndexFloat * (itemWidth + cellSpacing)
        targetContentOffset.pointee = CGPoint(x: adjacentItemOffsetX, y: target.y)
    }
}
