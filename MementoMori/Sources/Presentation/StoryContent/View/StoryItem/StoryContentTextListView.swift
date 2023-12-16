//
//  StoryItemTextListView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import UIKit

final class StoryContentTextListView: BaseView {
    
    //MARK: - UI
    private lazy var writerContentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.subtitle)
        label.textColor = Constant.Color.label
        label.numberOfLines = 1
        return label
    }()
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        backgroundColor = .systemBrown.withAlphaComponent(0.1)
        
        addSubview(writerContentLabel)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        writerContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            writerContentLabel.topAnchor.constraint(equalTo: topAnchor),
            writerContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.StoryItem.Comment.inset),
            writerContentLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constant.Layout.StoryItem.Comment.inset)
        ])
    }
}

//MARK: - Data
extension StoryContentTextListView {
    
    func configure(_ storyPost: StoryPost?) {
        guard let storyPost else { return }
        
        writerContentLabel.text = storyPost.content
    }
}
