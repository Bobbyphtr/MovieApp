//
//  HomeViewController.swift
//  MovieApp
//
//  Created by BobbyPhtr on 19/02/21.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    var vm : HomeViewModel!
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var homeCV: UICollectionView!
    @IBOutlet weak var homeCVLayout: UICollectionViewFlowLayout!
    
    private lazy var cellAreaInset : UIEdgeInsets = {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }()
    private lazy var cellSpacing : CGFloat = 18
    private lazy var columnCount : CGFloat = 1
    private lazy var sectionHeight : CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = vm.title
        
        homeCV.register(UINib(nibName: "HomeCell", bundle: .main), forCellWithReuseIdentifier: HomeCell.mReuseIdentifier)
        homeCV.register(UINib(nibName: "BigCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: BigCollectionViewCell.mReuseIdentifier)
        homeCV.register(UINib(nibName: "SectionHeader", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.mReuseIdentifier)
        
        homeCV.delegate = self
        homeCV.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.headerReferenceSize = CGSize(width: homeCV.frame.size.width, height: sectionHeight)
        homeCV.collectionViewLayout = layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalHorizontalSpacing = (cellAreaInset.left + cellAreaInset.right) + ((columnCount - 1)*cellSpacing)
        let width = floor((collectionView.bounds.width - totalHorizontalSpacing)/columnCount)
        
        if indexPath.section == 0 {
            return CGSize(width: width, height: width * 0.8)
        }
        
        return CGSize(width: width, height: width * 0.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.mReuseIdentifier, for: indexPath) as! SectionHeader
        headerView.frame.size.height = sectionHeight
        headerView.homeSection = HomeSection.allCases[indexPath.section]
        headerView.onSeeAllTapped = { section in
            self.vm.showAllCategory(category: section)
        }
        
        return headerView
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch HomeSection.allCases[indexPath.section] {
        case .nowPlaying:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigCollectionViewCell.mReuseIdentifier, for: indexPath) as! BigCollectionViewCell
            cell.viewModel = vm
            return cell
        case .popular:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.mReuseIdentifier, for: indexPath) as! HomeCell
            cell.viewModel = vm
            cell.currentSection = HomeSection.allCases[indexPath.section]
            return cell
        case .topRated:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.mReuseIdentifier, for: indexPath) as! HomeCell
            cell.viewModel = vm
            cell.currentSection = HomeSection.allCases[indexPath.section]
            return cell
        }
    }
    
    
}
