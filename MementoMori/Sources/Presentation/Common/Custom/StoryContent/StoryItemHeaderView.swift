//
//  StoryHeaderView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

final class StoryItemHeaderView: BaseView {
    
    var storyPost: StoryPost?
    
    private lazy var userProfileImageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(systemName: "book.circle")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var nicknameLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: Constant.FontSize.subtitle)
        view.textColor = Constant.Color.label
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var postTypeLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: Constant.FontSize.body)
        view.textColor = Constant.Color.label
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var ellipsisButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.ellipsis,
            for: .normal
        )
        return button
    }()
    
    private lazy var labelVerticalStackView = {
        let view = UIStackView(
            arrangedSubviews: [nicknameLabel, postTypeLabel]
        )
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillEqually
        view.spacing = 0
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(userProfileImageView)
        addSubview(labelVerticalStackView)
        addSubview(ellipsisButton)
    }
    
    override func configureLayout() {
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.Layout.StoryItem.Header.inset),
            userProfileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            userProfileImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            userProfileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        labelVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelVerticalStackView.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
            labelVerticalStackView.trailingAnchor.constraint(equalTo: ellipsisButton.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
            labelVerticalStackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            labelVerticalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        ellipsisButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ellipsisButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.Layout.StoryItem.Header.inset),
            ellipsisButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            ellipsisButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            ellipsisButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension StoryItemHeaderView {
    
    func configure(storyPost: StoryPost?) {
        self.storyPost = storyPost
        
        guard let storyPost = self.storyPost else { return }
        
        nicknameLabel.text = storyPost.userID
        
        switch storyPost.storyType {
        case .advertisement:
            postTypeLabel.text = "광고"
        case .location:
            postTypeLabel.text = storyPost.location
        }
    }
}
