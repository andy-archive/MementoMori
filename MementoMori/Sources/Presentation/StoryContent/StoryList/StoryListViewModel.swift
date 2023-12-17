//
//  StoryListViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import UIKit

import RxCocoa
import RxSwift

final class StoryListViewModel: ViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: Observable<Void>
        let textContentTap: PublishRelay<Void>
    }
    
    //MARK: - Output
    struct Output {
        let storyList: Observable<[StoryPost]>
    }
    
    //MARK: - Properties
    weak var coordinator: StoryContentCoordinator?
    private let storyListUseCase: StoryListUseCaseProtocol
    private let disposeBag = DisposeBag()
    var storyPostList = [StoryPost]()
    
    //MARK: - Initializer
    init(
        coordinator: StoryContentCoordinator,
        storyListUseCase: StoryListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.storyListUseCase = storyListUseCase
    }
    
    //MARK: - Transform Input into Output
    func transform(input: Input) -> Output {
        
        /// viewWillAppear일 때 게시글 요청 (GET)
        let storyList = input.viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.storyListUseCase.readStoryList()
            }
            .withUnretained(self)
            .map { owner, storyList in
                owner.coordinator?.finish()
                return storyList
            }
        
        /// 게시글 및 댓글 입력 시 댓글 화면 이동
        input.textContentTap
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.coordinator?.showCommentDetailViewController()
            }
            .disposed(by: disposeBag)
        
        return Output(
            storyList: storyList
        )
    }
    
}
