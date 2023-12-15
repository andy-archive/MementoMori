//
//  CommentDetailViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import UIKit

final class CommentDetailViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var titleView = {
        let view = UIView()
        return view
    }()
    
    //MARK: - ViewModel
    private let viewModel: CommentDetailViewModel
    
    //MARK: - Initializer
    init(
        viewModel: CommentDetailViewModel
    ) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - Bind with ViewModel
    override func bind() {
        
    }
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(titleView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.StoryItem.Footer.inset),
            titleView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
        ])
    }
}

//MARK: - Data
extension CommentDetailViewController {
    
    func configure(_ storyPost: StoryPost?) {
        guard let storyPost else { return }
        
    }
}
