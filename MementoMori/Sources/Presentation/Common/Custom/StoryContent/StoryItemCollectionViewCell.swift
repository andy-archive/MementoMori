//
//  StoryItemCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import UIKit

import Kingfisher

final class StoryItemCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var imageView = {
        let view = UIImageView()
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
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

//MARK: upload image
extension StoryItemCollectionViewCell {
    
    func loadImage(token: String?, path: String?) {
        
        guard let token,
              let path else { return }
        let urlString = MementoAPI.baseURL + path
        let modifier = AnyModifier { request in
            var result = request
            result.setValue(
                token,
                forHTTPHeaderField: "Authorization"
            )
            return result
        }
        
        guard let url = URL(string: urlString) else { return }
        let cgSize = CGSize(width: 200, height: 300)
        let downsamplingImageProcessor = DownsamplingImageProcessor(size: cgSize)
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.imageView.kf.indicatorType = .activity
                self.imageView.kf.setImage(
                    with: url,
                    options: [
                        .transition(.fade(0.2)),
                        .processor(downsamplingImageProcessor),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage
                    ]
                )
            }
        }
    }
}
