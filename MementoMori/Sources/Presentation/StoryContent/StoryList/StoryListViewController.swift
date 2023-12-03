//
//  StoryListViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class StoryListViewController: BaseViewController {
    
    private lazy var headerView = StoryListHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() { }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(headerView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
