//
//  StoryListCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

final class StoryListCollectionViewCell: BaseCollectionViewCell {
    
    private var storyPost: StoryPost?
    
    //MARK: - View Properties
    private lazy var itemHeaderView = StoryItemHeaderView()
    private lazy var itemCollectionView = StoryItemView()
    private lazy var itemFooterView = StoryItemFooterView()
    private lazy var commentTableView = {
        let view = UIView()
        view.backgroundColor = .systemBrown.withAlphaComponent(0.2)
        return view
    }()
    private lazy var listSeparatorView = SeparatorView()
    
    //MARK: - BaseCollectionViewCell
    override func configureUI() {
        super.configureUI()
        
        contentView.addSubview(itemHeaderView)
        contentView.addSubview(itemCollectionView)
        contentView.addSubview(itemFooterView)
        contentView.addSubview(commentTableView)
        contentView.addSubview(listSeparatorView)
    }
    
    override func configureLayout() {
        itemHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemHeaderView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            itemHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemHeaderView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryItem.Header.height)
        ])
        
        itemCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemCollectionView.topAnchor.constraint(equalTo: itemHeaderView.bottomAnchor),
            itemCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemCollectionView.heightAnchor.constraint(equalTo: itemCollectionView.widthAnchor, multiplier: 0.5),
        ])
        
        itemFooterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemFooterView.topAnchor.constraint(equalTo: itemCollectionView.bottomAnchor),
            itemFooterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemFooterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemFooterView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryItem.Footer.height)
        ])
        
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: itemFooterView.bottomAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: listSeparatorView.topAnchor)
        ])
        
        listSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listSeparatorView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            listSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            listSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

//MARK: - configureCell

extension StoryListCollectionViewCell {
    func configureCell(storyPost: StoryPost?) {
        self.storyPost = storyPost
        itemHeaderView.configure(storyPost: storyPost)
        itemCollectionView.configure(storyPost: storyPost)
    }
}
