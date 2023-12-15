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
        let storyList: Signal<[StoryPost]>
    }
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    weak var coordinator: StoryContentCoordinator?
    private let storyListUseCase: StoryListUseCaseProtocol
    var storyPostList = [StoryPost]()
    
    //MARK: - Initializer
    init(
        coordinator: StoryContentCoordinator,
        storyListUseCase: StoryListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.storyListUseCase = storyListUseCase
    }
    
    //MARK: - Transform from Input to Output
    func transform(input: Input) -> Output {
        let storyList = input
            .viewWillAppear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.storyListUseCase.fetchStoryListStream()
            }
            .withUnretained(self)
            .map { owner, storyList in
                guard let storyList = storyList else {
                    owner.coordinator?.finish()
                    return [StoryPost]()
                }
                return storyList
            }
            .asSignal(onErrorJustReturn: [StoryPost]())
        
        input
            .textContentTap
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
