//
//  StoryItemCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import UIKit

final class StoryItemCollectionViewCell: BaseCollectionViewCell {
    
    private var imageURL: String?
    
    private let colorList: [UIColor] = [.systemBlue, .systemRed, .systemGreen, .systemCyan, .systemYellow, .systemPink, .systemOrange]
    
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
