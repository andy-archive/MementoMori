//
//  UserProfileViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class UserProfileViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var myView = {
        let view = UIView()
        return view
    }()
    
    //MARK: - ViewModel
    private let viewModel: UserProfileViewModel
    
    //MARK: - Initializer
    init(
        viewModel: UserProfileViewModel
    ) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - Bind ViewController to ViewModel
    override func bind() {
        
    }
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        /// View Hierarchy
        view.addSubview(myView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        myView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.StoryItem.Footer.inset),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.StoryItem.Footer.inset),
            myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constant.Layout.StoryItem.Footer.inset),
            myView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            myView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            myView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - Data
extension UserProfileViewController {
    
    func configure(_ user: User?) {
        guard let user else { return }
    }
}

