//
//  StoryListViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

import RxCocoa
import RxSwift

final class StoryListViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var headerView = StoryListHeaderView()
    private lazy var bodyView = StoryListBodyView()
    
    //MARK: - ViewModel
    private let viewModel: StoryListViewModel
    
    //MARK: - Initialzer
    init(
        viewModel: StoryListViewModel
    ) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - Bind ViewController to ViewModel
    override func bind() {
        let input = StoryListViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in }.throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            textContentTap: bodyView.textContentViewTap
        )
        let output = viewModel.transform(input: input)
        
        output.storyList
            .asSignal(onErrorJustReturn: [])
            .emit(with: self) { owner, postList in
                owner.bodyView.postList = postList
                owner.bodyView.configure()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - UI Configuration
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(headerView)
        view.addSubview(bodyView)
    }
    
    //MARK: - Layouts
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
