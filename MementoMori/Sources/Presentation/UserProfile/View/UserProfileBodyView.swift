//
//  UserProfileBodyView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/21/23.
//

import UIKit

final class UserProfileBodyView: BaseView {
    
    //MARK: - UI
    private lazy var userImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemOrange
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var userImagePlusButton = {
        let button = UIButton()
        var config = UIButton.Configuration.borderless()
        config.image = Constant.Image.System.plusCircleFill
        config.buttonSize = .small
        config.baseForegroundColor = Constant.Color.label
        config.baseBackgroundColor = .systemBackground
        button.configuration = config
        return button
    }()
    
    private lazy var userPostButton = {
        let button = UIButton()
        var config = UIButton.Configuration.borderless()
        config.buttonSize = .small
        config.title = "23"
        config.subtitle = "게시글"
        config.titleAlignment = .center
        config.baseForegroundColor = Constant.Color.label
        button.configuration = config
        return button
    }()
    
    private lazy var userFollowerButton = {
        let button = UIButton()
        var config = UIButton.Configuration.borderless()
        config.buttonSize = .small
        config.title = "23"
        config.subtitle = "팔로워"
        config.titleAlignment = .center
        config.baseForegroundColor = Constant.Color.label
        button.configuration = config
        return button
    }()
    
    private lazy var userFollowingButton = {
        let button = UIButton()
        var config = UIButton.Configuration.borderless()
        config.buttonSize = .small
        config.title = "23"
        config.subtitle = "팔로잉"
        config.titleAlignment = .center
        config.baseForegroundColor = Constant.Color.label
        button.configuration = config
        return button
    }()
    
    private lazy var userIntroLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.subtitle)
        label.textColor = Constant.Color.label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var userProfileEditButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .small
        config.baseForegroundColor = Constant.Color.label
        config.baseBackgroundColor = Constant.Color.Button.configuration
        config.title = "프로필 편집"
        button.configuration = config
        return button
    }()
    
    private lazy var userProfileShareButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .small
        config.baseForegroundColor = Constant.Color.label
        config.baseBackgroundColor = Constant.Color.Button.configuration
        config.title = "프로필 공유"
        button.configuration = config
        return button
    }()
    
    private lazy var searchFriendButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.buttonSize = .small
        config.image = Constant.Image.System.personCirclePlus
        config.baseForegroundColor = Constant.Color.label
        config.baseBackgroundColor = Constant.Color.Button.configuration
        button.configuration = config
        return button
    }()
    
    //MARK: - View Configuration
    override func configureUI() {
        
        ///View Hierarchy
        addSubview(userImageView)
        userImageView.addSubview(userImagePlusButton)
        addSubview(userPostButton)
        addSubview(userFollowerButton)
        addSubview(userFollowingButton)
        addSubview(userIntroLabel)
        addSubview(userProfileEditButton)
        addSubview(userProfileShareButton)
        addSubview(searchFriendButton)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            userImageView.heightAnchor.constraint(equalToConstant: Constant.Layout.UserProfile.profileImageSize),
            userImageView.widthAnchor.constraint(equalToConstant: Constant.Layout.UserProfile.profileImageSize)
        ])
        
        userImagePlusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImagePlusButton.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor),
            userImagePlusButton.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor)
        ])
        
        userPostButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userPostButton.trailingAnchor.constraint(equalTo: userFollowerButton.leadingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            userPostButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
        ])
        
        userFollowerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userFollowerButton.trailingAnchor.constraint(equalTo: userFollowingButton.leadingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            userFollowerButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
        ])
        
        userFollowingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userFollowingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            userFollowingButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
        ])
        
        userIntroLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIntroLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userIntroLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            userIntroLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            userIntroLabel.heightAnchor.constraint(equalToConstant: Constant.Layout.UserProfile.profileImageSize)
        ])
        
        userProfileEditButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userProfileEditButton.topAnchor.constraint(equalTo: userIntroLabel.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            userProfileEditButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constant.Layout.UserProfile.EditStack.inset),
            userProfileEditButton.heightAnchor.constraint(equalToConstant: Constant.Layout.UserProfile.EditStack.buttonHeight),
            userProfileEditButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constant.Layout.UserProfile.EditStack.buttonWidthRatio)
        ])
        
        userProfileShareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userProfileShareButton.topAnchor.constraint(equalTo: userIntroLabel.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            userProfileShareButton.leadingAnchor.constraint(equalTo: userProfileEditButton.trailingAnchor, constant: Constant.Layout.UserProfile.EditStack.inset),
            userProfileShareButton.heightAnchor.constraint(equalToConstant: Constant.Layout.UserProfile.EditStack.buttonHeight),
            userProfileShareButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constant.Layout.UserProfile.EditStack.buttonWidthRatio)
   
        ])
        
        searchFriendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchFriendButton.topAnchor.constraint(equalTo: userIntroLabel.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            searchFriendButton.leadingAnchor.constraint(equalTo: userProfileShareButton.trailingAnchor, constant: Constant.Layout.UserProfile.EditStack.inset),
            searchFriendButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constant.Layout.UserProfile.EditStack.inset),
            searchFriendButton.heightAnchor.constraint(equalToConstant: Constant.Layout.UserProfile.EditStack.buttonHeight),
            searchFriendButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constant.Layout.UserProfile.EditStack.findFriendWidthRatio)
        ])
    }
}
