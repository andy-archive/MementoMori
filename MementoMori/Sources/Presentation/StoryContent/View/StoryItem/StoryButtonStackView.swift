//
//  StoryButtonStackView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import UIKit

final class StoryButtonStackView: BaseView {
    
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
    
    private lazy var bookmarkButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.bookmark,
            for: .normal
        )
        return button
    }()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(bookmarkButton)
    }
    
    override func configureLayout() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            likeButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            likeButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            likeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            commentButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            commentButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            commentButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            shareButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            shareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            shareButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookmarkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.Layout.StoryItem.Footer.inset),
            bookmarkButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            bookmarkButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            bookmarkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
