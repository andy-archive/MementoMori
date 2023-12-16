//
//  StoryListBodyView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import UIKit

import RxCocoa
import RxGesture

final class StoryListBodyView: BaseView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, StoryPost>
    
    //MARK: - UI
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .configureFlowLayout(
            numberOfItemInRow: 1,
            sectionSpacing: 0,
            itemSpacing: 0,
            scrollDirection: .vertical
        )
    )
    
    //MARK: - Properties
    private var dataSource: DataSource?
    lazy var postList: [StoryPost] = []
    let textContentViewTap = PublishRelay<Void>()
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        addSubview(collectionView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

//MARK: - Data
extension StoryListBodyView {
    
    func configure() {
        configureCollectionView()
        dataSource = configureDataSource()
        
        let snapshot = configureSnapshot(self.postList)
        dataSource?.apply(snapshot)
    }
}

//MARK: - Configure UICollectionView
extension StoryListBodyView: UICollectionViewDelegateFlowLayout {
    
    enum Section: CaseIterable {
        case main
    }
    
    private func configureCollectionView() {
        collectionView.register(
            StoryCollectionViewCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(StoryCollectionViewCell.self)
        )
        collectionView.delegate = self
    }
    
    private func configureDataSource() -> DataSource {
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NSStringFromClass(StoryCollectionViewCell.self),
                for: indexPath)
                    as? StoryCollectionViewCell
            else {
                return StoryCollectionViewCell()
            }
            let keychain = KeychainRepository.shared
            
            cell.configureCell(storyPost: itemIdentifier)
            cell.textContentView.rx.tapGesture()
                .when(.recognized)
                .withUnretained(self)
                .subscribe { owner, value in
                    guard let storyID = itemIdentifier.id else { return }
                    if keychain.save(key: "", value: storyID, type: .storyID) {
                        owner.textContentViewTap.accept(Void())
                    }
                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    private func configureSnapshot(_ postList: [StoryPost]) -> NSDiffableDataSourceSnapshot<Section, StoryPost> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, StoryPost>()
        snapshot.appendSections([.main])
        snapshot.appendItems(postList, toSection: .main)
        
        return snapshot
    }
}
