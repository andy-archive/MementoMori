//
//  StoryCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

import RxGesture
import RxSwift

final class StoryCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI
    private lazy var headerView = StoryHeaderView()
    private lazy var imageListView = StoryImageListView()
    private lazy var footerView = StoryButtonStackView()
    lazy var textContentView = StoryContentTextListView()
    private lazy var separatorView = SeparatorView()
    
    //MARK: - ContentView Configuration
    override func configureUI() {
        super.configureUI()
        
        contentView.addSubview(headerView)
        contentView.addSubview(imageListView)
        contentView.addSubview(footerView)
        contentView.addSubview(textContentView)
        contentView.addSubview(separatorView)
    }
    
    //MARK: - Layouts
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
        
        textContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textContentView.topAnchor.constraint(equalTo: footerView.bottomAnchor),
            textContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textContentView.bottomAnchor.constraint(equalTo: separatorView.topAnchor)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

//MARK: - Data
extension StoryCollectionViewCell {
    
    func configureCell(storyPost: StoryPost?) {
        headerView.configure(storyPost)
        imageListView.configure(storyPost)
        textContentView.configure(storyPost)
    }
}
