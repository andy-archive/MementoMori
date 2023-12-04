//
//  StoryListCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

final class StoryListCollectionViewCell: BaseCollectionViewCell {
    
    var storyPost: StoryPost?
    
    private lazy var itemHeaderView = StoryItemHeaderView()
    
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
    
    private lazy var listSeparatorView = SeparatorView()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(itemHeaderView)
        addSubview(itemImageView)
        addSubview(itemFooterStackView)
        addSubview(listSeparatorView)
    }
    
    override func configureLayout() {
        itemHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemHeaderView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            itemHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
            itemHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal / 2),
            itemHeaderView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryItem.Header.height)
        ])
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: itemHeaderView.bottomAnchor, constant: 8),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
        ])
        
        itemFooterStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemFooterStackView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8),
            itemFooterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
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
        itemHeaderView.configureUser(storyPost: storyPost)
    }
}
