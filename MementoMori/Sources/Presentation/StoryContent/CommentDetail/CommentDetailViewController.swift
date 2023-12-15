//
//  CommentDetailViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import UIKit

final class CommentDetailViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var headerView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constant.FontSize.title)
        label.textColor = Constant.Color.label
        label.numberOfLines = 1
        label.text = "댓글"
        return label
    }()
    
    private lazy var separatorView = SeparatorView()
    private lazy var tableView = UITableView()
    
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
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(separatorView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.CommentDetail.Header.height)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constant.Layout.CommentDetail.Header.inset),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: headerView.widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Data
extension CommentDetailViewController {
    
    func configure(_ storyPost: StoryPost?) {
        guard let storyPost else { return }
        
    }
}
