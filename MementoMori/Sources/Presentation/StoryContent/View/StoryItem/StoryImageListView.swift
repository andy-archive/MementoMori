//
//  StoryItemImageListView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import UIKit

final class StoryImageListView: BaseView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    
    private var dataSource: DataSource?
    
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
            imageCollectionView.topAnchor.constraint(equalTo: topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension StoryImageListView: UICollectionViewDelegateFlowLayout {
    
    enum Section: CaseIterable {
        case main
    }
    
    private func configureCollectionView() {
        imageCollectionView.register(
            StoryImageCollectionViewCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(StoryImageCollectionViewCell.self)
        )
        imageCollectionView.delegate = self
    }
    
    private func configureDataSource() -> DataSource {
        
        return DataSource(collectionView: imageCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NSStringFromClass(StoryImageCollectionViewCell.self),
                for: indexPath
            ) as? StoryImageCollectionViewCell
            else { return UICollectionViewCell() }
            
            cell.loadImage(path: itemIdentifier)
            
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

extension StoryImageListView {
    
    func configure(_ storyPostItem: StoryPost?) {
        
        guard 
            let storyPostItem,
            let imageFilePathList = storyPostItem.imageFilePathList
        else { return }
        
        configureCollectionView()
        dataSource = configureDataSource()
        
        let snapshot = configureSnapshot(imageFilePathList)
        
        dataSource?.apply(snapshot)
    }
}
