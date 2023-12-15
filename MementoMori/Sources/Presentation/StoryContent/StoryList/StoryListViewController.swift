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
    private lazy var bodyView = StoryListBodyView()
    
    private let viewModel: StoryListViewModel
    
    init(
        viewModel: StoryListViewModel
    ) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func bind() {
        let input = StoryListViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in }.throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        let output = viewModel.transform(input: input)
        
        output
            .storyList
            .emit(with: self) { owner, postList in
                owner.bodyView.postList = postList
                owner.bodyView.configure()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(headerView)
        view.addSubview(bodyView)
    }
    
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
        
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bodyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
