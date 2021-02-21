//
//  BigCollectionViewCell.swift
//  MovieApp
//
//  Created by BobbyPhtr on 20/02/21.
//

import UIKit
import RxSwift
import RxCocoa

class BigCollectionViewCell: UICollectionViewCell {

    static let mReuseIdentifier = "HiglightsSection"
    
    @IBOutlet weak var higlightsCV: UICollectionView!
    
    private var collumnCount = 1
    private var cellSpacing : CGFloat = 8
    private var peekWidth : CGFloat = 8
    private lazy var itemWidth : CGFloat = max(CGFloat(0), higlightsCV.frame.size.width - CGFloat(2 * (cellSpacing + peekWidth)))
    
    var viewModel : HomeViewModel! {
        didSet {
            configureView()
        }
    }
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        higlightsCV.register(UINib(nibName: "HighlightsCell", bundle: .main), forCellWithReuseIdentifier: HighlightsCell.mReuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let leftRightInset : CGFloat = cellSpacing + peekWidth
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        layout.minimumInteritemSpacing = 0
        
        higlightsCV.collectionViewLayout = layout
        higlightsCV.delegate = self
    }

    private func configureView(){
        higlightsCV.dataSource = nil
        viewModel.nowPlayingMoviesRelay.bind(to: higlightsCV.rx.items) { cv, row, element in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = cv.dequeueReusableCell(withReuseIdentifier: HighlightsCell.mReuseIdentifier, for: indexPath) as! HighlightsCell
            self.viewModel.getBackdropImage(backdropUrl: element.backdropPath) { (image) in
                cell.backdropImageView.image = image
            }
            cell.genreLabel.text = self.viewModel.genresString(genresID: element.genreIDs)
            cell.titleLabel.text = element.title
            cell.subtitleLabel.text = element.overview
            return cell
        }.disposed(by: disposeBag)
        
        higlightsCV.rx.modelSelected(Movie.self).bind {
            model in
            self.viewModel.showMovieDetail(movieId: model.id)
        }.disposed(by: disposeBag)
        
    }
    
    /// Letak scrollview sekarang
    private var currentOffset : CGPoint?
    /// Seberapa besar scroll hingga scrollview bergerak  ke index selanjutnya
    private var scrollThreshold : CGFloat = 0.8
    
}

extension BigCollectionViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: higlightsCV.frame.width - CGFloat(2 * (cellSpacing + peekWidth)), height: higlightsCV.frame.height)
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
