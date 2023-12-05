//
//  StoryListCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

final class StoryListCollectionViewCell: BaseCollectionViewCell {
    
    private var storyPost: StoryPost?
    
    private lazy var itemHeaderView = StoryItemHeaderView()
    private lazy var itemCollectionView = StoryItemCollectionView()
    
    private lazy var itemImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(systemName: "photo.stack.fill")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var likeButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.heart,
            for: .normal
        )
        return button
    }()
    
    private lazy var commentButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.bubbleTwo,
            for: .normal
        )
        return button
    }()
    
    private lazy var shareButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.paperplane,
            for: .normal
        )
        return button
    }()
    
    private lazy var itemFooterStackView = {
        let view = UIStackView(
            arrangedSubviews: [likeButton, commentButton, shareButton]
        )
        view.distribution = .fill
        view.spacing = 12
        return view
    }()    
    
    private lazy var commentTableView = {
        let view = UIView()
        view.backgroundColor = .systemBrown.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var listSeparatorView = SeparatorView()
    
    override func configureUI() {
        super.configureUI()
        
        contentView.addSubview(itemHeaderView)
        contentView.addSubview(itemCollectionView)
        contentView.addSubview(itemFooterStackView)
        contentView.addSubview(commentTableView)
        contentView.addSubview(listSeparatorView)
    }
    
    override func configureLayout() {
        itemHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemHeaderView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            itemHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
            itemHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal / 2),
            itemHeaderView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryItem.Header.height)
        ])
        
        itemCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemCollectionView.topAnchor.constraint(equalTo: itemHeaderView.bottomAnchor),
            itemCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemCollectionView.heightAnchor.constraint(equalTo: itemCollectionView.widthAnchor, multiplier: 0.5),
        ])
        
        itemFooterStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemFooterStackView.topAnchor.constraint(equalTo: itemCollectionView.bottomAnchor),
            itemFooterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
            itemFooterStackView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryItem.Footer.height)
        ])
        
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: itemFooterStackView.bottomAnchor),
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

//MARK: configureCell

extension StoryListCollectionViewCell {
    func configureCell(storyPost: StoryPost?) {
        self.storyPost = storyPost
        itemHeaderView.configure(storyPost: storyPost)
        itemCollectionView.configure(storyPost: storyPost)
    }
}
