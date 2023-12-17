//
//  StoryUploadHeaderView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/7/23.
//

import UIKit

final class StoryUploadHeaderView: BaseView {
    
    //MARK: - UI
    lazy var cancelButton = {
        let button = UIButton()
        button.setImage(Constant.Image.System.xMark, for: .normal)
        return button
    }()
    lazy var newPostLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constant.FontSize.title)
        label.textColor = Constant.Color.label
        label.numberOfLines = 1
        label.text = "새 게시물"
        return label
    }()
    lazy var nextButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(Constant.Color.Button.valid, for: .normal)
        return button
    }()
    private lazy var separatorView = SeparatorView()
    
    //MARK: - View Hierarchies
    override func configureUI() {
        super.configureUI()
        
        addSubview(cancelButton)
        addSubview(newPostLabel)
        addSubview(nextButton)
        addSubview(separatorView)
    }
    
    //MARK: - View Layouts
    override func configureLayout() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            cancelButton.trailingAnchor.constraint(lessThanOrEqualTo: nextButton.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        newPostLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newPostLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            newPostLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: topAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
