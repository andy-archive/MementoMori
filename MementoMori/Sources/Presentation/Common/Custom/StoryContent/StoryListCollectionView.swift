//
//  StoryListCollectionView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import UIKit

final class StoryListCollectionView: BaseView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, StoryPost>
    
    private var dataSource: DataSource?
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .setCollectionViewLayout(
            numberOfItem: 1,
            sectionSpacing: 0,
            itemSpacing: 0
        )
    )
    
    private var postList: [StoryPost] = [
        StoryPost(id: "abcd",
                  userId: "abcd1234",
                  storyType: .advertisement,
                  imageIdList: ["98769876"],
                  commentIdList: ["5678"],
                  location: "서울 영등포구 문래동",
                  isLiked: true,
                  isSavedToMyCollection: false,
                  content: "안녕하세요",
                  createdAt: Date()
                 ),
        StoryPost(id: "efgh",
                  userId: "5678",
                  storyType: .location,
                  imageIdList: ["12341234"],
                  commentIdList: ["76547654"],
                  location: "서울 영등포구 문래동",
                  isLiked: true,
                  isSavedToMyCollection: false,
                  content: "Ciao",
                  createdAt: Date()
                 ),
        StoryPost(id: "ijkl",
                  userId: "9638",
                  storyType: .advertisement,
                  imageIdList: ["12341234"],
                  commentIdList: ["76547654"],
                  location: "서울 영등포구 문래동",
                  isLiked: true,
                  isSavedToMyCollection: false,
                  content: "Hola",
                  createdAt: Date()
                 ),
    ]
    
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

extension StoryListCollectionView: UICollectionViewDelegateFlowLayout {
    
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
