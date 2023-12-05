//
//  StoryItemCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import UIKit

final class StoryItemCollectionViewCell: BaseCollectionViewCell {
    
    private var imageURL: String?
    
    private let colorList: [UIColor] = [.systemBlue.withAlphaComponent(0.8), .systemRed.withAlphaComponent(0.8), .systemGreen.withAlphaComponent(0.8), .systemPink.withAlphaComponent(0.8)]
    
    private lazy var imageView = {
        let view = UIView()
        view.backgroundColor = colorList.randomElement()!
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        
        contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

//MARK: configureCell

extension StoryItemCollectionViewCell {
    func configure(imageURL: String?) {
        self.imageURL = imageURL
    }
}
