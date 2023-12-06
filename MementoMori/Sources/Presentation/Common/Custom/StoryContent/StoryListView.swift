//
//  StoryListView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import UIKit

final class StoryListView: BaseView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, StoryPost>
    
    private var dataSource: DataSource?
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .configureFlowLayout(
            numberOfItemInRow: 1,
            sectionSpacing: 0,
            itemSpacing: 0,
            scrollDirection: .vertical
        )
    )
    
    lazy var postList: [StoryPost] = []
    
    override func configureUI() {
        super.configureUI()
        
        configureCollectionView()
        dataSource = configureDataSource()
        
        let snapshot = configureSnapshot(self.postList)
        dataSource?.apply(snapshot)
        
        addSubview(collectionView)
    }
    
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

//MARK: UICollectionViewDelegateFlowLayout

extension StoryListView: UICollectionViewDelegateFlowLayout {
    
    enum Section: CaseIterable {
        case main
    }
    
    private func configureCollectionView() {
        collectionView.register(
            StoryListCollectionViewCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(StoryListCollectionViewCell.self)
        )
        collectionView.delegate = self
    }
    
    private func configureDataSource() -> DataSource {
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NSStringFromClass(StoryListCollectionViewCell.self),
                for: indexPath)
                    as? StoryListCollectionViewCell
            else {
                return StoryListCollectionViewCell()
            }
            
            cell.configureCell(storyPost: itemIdentifier)
            
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
