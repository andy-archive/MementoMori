//
//  StoryListViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

import RxSwift

final class StoryListViewController: BaseViewController {
    
    private lazy var headerView = StoryListHeaderView()
    private lazy var storyView = StoryListView()
    
    private let viewModel: StoryListViewModel
    
    init(
        viewModel: StoryListViewModel
    ) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = StoryListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.map { _ in }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        let output = viewModel.transform(input: input)
        
        output
            .storyList
            .emit(with: self) { owner, value in
                owner.storyView.postList = value
                owner.storyView.configure()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(headerView)
        view.addSubview(storyView)
    }
    
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
        
        storyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            storyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
