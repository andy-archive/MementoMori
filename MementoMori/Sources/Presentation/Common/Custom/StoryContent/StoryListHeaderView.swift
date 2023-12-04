//
//  StoryListHeaderView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import UIKit

final class StoryListHeaderView: BaseView {
    
    private let titleLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Noteworthy", size: 25)
        label.textColor = Constant.Color.label
        label.numberOfLines = 1
        label.text = "Memento Mori"
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let followingButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.personTwo,
            for: .normal
        )
        return button
    }()
    
    private let favoriteButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.star,
            for: .normal
        )
        return button
    }()
    
    private lazy var buttonStackView = {
        let view = UIStackView(
            arrangedSubviews: [followingButton, favoriteButton]
        )
        view.spacing = 8
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    private lazy var stackView = {
        let view = UIStackView(
            arrangedSubviews: [titleLabel, buttonStackView]
        )
        view.distribution = .fill
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(stackView)
    }
    
    override func configureLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
