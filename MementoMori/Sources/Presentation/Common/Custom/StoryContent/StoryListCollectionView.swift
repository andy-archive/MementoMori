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
        collectionViewLayout: .configureFlowLayout(
            numberOfItemInRow: 1,
            sectionSpacing: 0,
            itemSpacing: 0,
            scrollDirection: .vertical
        )
    )
    
    private var postList: [StoryPost] = [
        StoryPost(
            id: "abcd",
            userID: "abcd1234",
            title: "오늘은...",
            content: "안녕하세요",
            imageList: ["98769876", "1230382", "123093012"],
            commentList: ["5678"],
            location: "서울 영등포구 문래동",
            isLiked: true,
            isSavedToMyCollection: false,
            createdAt: "2023-02-02",
            storyType: .advertisement
        ),
        StoryPost(
            id: "efgh",
            userID: "5678",
            title: "이탈리아",
            content: "Ciao",
            imageList: ["12341234", "21383123", "21301239"],
            commentList: ["76547654"],
            location: "서울 마포구 공덕동",
            isLiked: true,
            isSavedToMyCollection: false,
            createdAt: "2023-02-02",
            storyType: .location
        ),
        StoryPost(
            id: "ijkl",
            userID: "9638",
            title: "스페인",
            content: "Hola",
            imageList: ["12341234", "23123092", "120391230923", "123213231"],
            commentList: ["76547654"],
            location: "부산 해운대구 우동",
            isLiked: true,
            isSavedToMyCollection: false,
            createdAt: "2023-02-02",
            storyType: .advertisement
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
