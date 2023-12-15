//
//  StoryItemTextListView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import UIKit

final class StoryContentTextListView: BaseView {
    
    //MARK: - (1) UI
    private lazy var creatorCommentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.subtitle)
        label.textColor = Constant.Color.label
        label.numberOfLines = 1
        return label
    }()
    
    //MARK: - (2) View Configuration
    override func configureUI() {
        super.configureUI()
        
        backgroundColor = .systemBrown.withAlphaComponent(0.1)
        
        addSubview(creatorCommentLabel)
    }
    
    //MARK: - (3) Layouts
    override func configureLayout() {
        creatorCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creatorCommentLabel.topAnchor.constraint(equalTo: topAnchor),
            creatorCommentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.StoryItem.Comment.inset),
            creatorCommentLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constant.Layout.StoryItem.Comment.inset)
        ])
    }
}

//MARK: - (4) Data
extension StoryContentTextListView {
    
    func configure(_ storyPost: StoryPost?) {
        guard let storyPost else { return }
        
        creatorCommentLabel.text = storyPost.content
    }
}
