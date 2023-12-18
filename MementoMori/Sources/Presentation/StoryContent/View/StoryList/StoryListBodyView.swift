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
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, StoryPost>
    
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
    
    //MARK: - UI Configuration
    override func configureUI() {
        super.configureUI()
        
        addSubview(collectionView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

//MARK: - Data
extension StoryListBodyView {
    
    func configure() {
        configureCollectionView()
        dataSource = configureDataSource()
        
        let snapshot = configureSnapshot(postList)
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
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
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
        
        return dataSource
    }
    
    private func configureSnapshot(_ postList: [StoryPost]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(postList, toSection: .main)
        
        return snapshot
    }
}
