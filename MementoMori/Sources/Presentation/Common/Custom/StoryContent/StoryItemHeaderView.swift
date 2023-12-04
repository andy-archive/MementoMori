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
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private lazy var userInfoStackView = {
        let view = UIStackView(
            arrangedSubviews: [userProfileImageView, labelVerticalStackView]
        )
        view.distribution = .fill
        view.spacing = 8
        return view
    }()
    
    private lazy var labelVerticalStackView = {
        let view = UIStackView(
            arrangedSubviews: [nicknameLabel, postTypeLabel]
        )
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 2
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private lazy var stackView = {
        let view = UIStackView(
            arrangedSubviews: [userInfoStackView, ellipsisButton]
        )
        view.distribution = .fill
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(stackView)
        
        configureUser(storyPost: storyPost)
    }
    
    override func configureLayout() {
        NSLayoutConstraint.activate([
            userProfileImageView.widthAnchor.constraint(equalToConstant: 30),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal / 2),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension StoryItemHeaderView {
    
    func configureUser(storyPost: StoryPost?) {
        self.storyPost = storyPost
        
        guard let storyPost = self.storyPost else { return }
        
        nicknameLabel.text = storyPost.userId
        
        switch storyPost.storyType {
        case .advertisement:
            postTypeLabel.text = "광고"
        case .location:
            postTypeLabel.text = storyPost.location
        }
    }
}
