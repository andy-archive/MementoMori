//
//  CommentDetailViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import UIKit

final class CommentDetailViewController: BaseViewController {
    
    //MARK: Properties
    private let keychain = KeychainRepository.shared
    
    //MARK: - UI
    private lazy var titleLabel = {
        let label = UILabel()
        return label
    }()
    
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
        
        guard let storyID = keychain.find(key: "", type: .storyID)
        else { return }
        
        titleLabel.text = storyID
        
        view.addSubview(titleLabel)
        view.addSubview(titleView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.StoryItem.Footer.inset),
            titleLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
        ])
    }
}

//MARK: - Data
extension CommentDetailViewController {
    
    func configure(_ storyPost: StoryPost?) {
        guard let storyPost else { return }
        
    }
}
