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
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let storyList: Signal<[StoryPost]>
    }
    
    let disposeBag = DisposeBag()
    weak var coordinator: StoryContentCoordinator?
    private let storyListUseCase: StoryListUseCaseProtocol
    
    init(
        coordinator: StoryContentCoordinator,
        storyListUseCase: StoryListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.storyListUseCase = storyListUseCase
    }
    
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
            
        return Output(
            storyList: storyList
        )
    }
    
}
