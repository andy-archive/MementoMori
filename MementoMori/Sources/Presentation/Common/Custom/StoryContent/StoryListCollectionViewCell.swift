//
//  StoryListCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

final class StoryListCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var nicknameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: Constant.FontSize.title)
        view.textColor = Constant.Color.label
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var imageView = {
        let view = UIImageView(frame: .zero)
        view.image = UIImage(systemName: "photo.stack.fill")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemYellow
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
    
    private lazy var separatorView = SeparatorView()
    
    override func configureUI() {
        super.configureUI()
        
        self.backgroundColor = .systemGreen.withAlphaComponent(0.8)
        
        addSubview(nicknameLabel)
        addSubview(imageView)
        addSubview(likeButton)
    }
    
    override func configureLayout() {
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
        ])
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal)
        ])
        
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func configureCell(nickname: String) {
        nicknameLabel.text = nickname
    }
}
