//
//  StoryItemCollectionView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import UIKit

final class StoryItemCollectionView: BaseView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    
    private var dataSource: DataSource?
    private var storyPost: StoryPost?
    
    private lazy var imageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .configureFlowLayout(
            numberOfItemInRow: 1,
            sectionSpacing: .zero,
            itemSpacing: .zero,
            scrollDirection: .horizontal
        )
    )

    override func configureUI() {
        super.configureUI()
        
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.showsHorizontalScrollIndicator = false
        
        addSubview(imageCollectionView)
    }
    
    override func configureLayout() {
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

//MARK: UICollectionViewDelegateFlowLayout


extension StoryItemCollectionView: UICollectionViewDelegateFlowLayout {
    
    enum Section: CaseIterable {
        case main
    }
    
    private func configureCollectionView() {
        imageCollectionView.register(
            StoryItemCollectionViewCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(StoryItemCollectionViewCell.self)
        )
        imageCollectionView.delegate = self
    }
    
    private func configureDataSource() -> DataSource {
        
        return DataSource(collectionView: imageCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NSStringFromClass(StoryItemCollectionViewCell.self),
                for: indexPath)
                    as? StoryItemCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(imageURL: itemIdentifier)
            
            return cell
        }
    }
    
    private func configureSnapshot(_ imageList: [String]?) -> NSDiffableDataSourceSnapshot<Section, String> {
        guard let imageList = imageList else { return NSDiffableDataSourceSnapshot() }
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(imageList, toSection: .main)
        
        return snapshot
    }
}

extension StoryItemCollectionView {
    func configure(storyPost: StoryPost?) {
        
        guard let storyPost else { return }
        
        self.storyPost = storyPost
        
        configureCollectionView()
        dataSource = configureDataSource()
        
        let snapshot = configureSnapshot(storyPost.imageIdList)
        dataSource?.apply(snapshot)
    }
}
