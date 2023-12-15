//
//  StoryCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

final class StoryCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - (1) UI
    private lazy var headerView = StoryHeaderView()
    private lazy var imageListView = StoryImageListView()
    private lazy var footerView = StoryButtonStackView()
    private lazy var textListView = StoryContentTextListView()
    private lazy var separatorView = SeparatorView()
    
    //MARK: - (2) ContentView Configuration
    override func configureUI() {
        super.configureUI()
        
        contentView.addSubview(headerView)
        contentView.addSubview(imageListView)
        contentView.addSubview(footerView)
        contentView.addSubview(textListView)
        contentView.addSubview(separatorView)
    }
    
    //MARK: - (3) Layouts
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryItem.Header.height)
        ])
        
        imageListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageListView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            imageListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageListView.heightAnchor.constraint(equalTo: imageListView.widthAnchor, multiplier: 0.5),
        ])
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: imageListView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryItem.Footer.height)
        ])
        
        textListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textListView.topAnchor.constraint(equalTo: footerView.bottomAnchor),
            textListView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textListView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textListView.bottomAnchor.constraint(equalTo: separatorView.topAnchor)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

//MARK: - (4) Data
extension StoryCollectionViewCell {
    
    func configureCell(storyPost: StoryPost?) {
        headerView.configure(storyPost)
        imageListView.configure(storyPost)
        textListView.configure(storyPost)
    }
}
