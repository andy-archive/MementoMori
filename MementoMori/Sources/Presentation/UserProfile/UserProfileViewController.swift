//
//  UserProfileViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class UserProfileViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var headerView = UserProfileHeaderView()
    
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
        view.addSubview(headerView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
    }
}

//MARK: - Data
extension UserProfileViewController {
    
    func configure(_ user: User?) {
        guard let user else { return }
    }
}

