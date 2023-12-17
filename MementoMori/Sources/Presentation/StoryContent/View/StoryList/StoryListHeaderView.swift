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
        return label
    }()
    
    lazy var followingButton = {
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
        return view
    }()
    
    private lazy var separatorView = SeparatorView()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(titleLabel)
        addSubview(buttonStackView)
        addSubview(separatorView)
    }
    
    override func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: buttonStackView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            titleLabel.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constant.Layout.Common.Inset.vertical / 2)
        ])
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            buttonStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constant.Layout.Common.Inset.vertical / 2)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
