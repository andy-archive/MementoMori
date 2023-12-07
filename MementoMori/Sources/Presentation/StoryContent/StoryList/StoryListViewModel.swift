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
        let storyList: Driver<[StoryPost]>
    }
    
    weak var coordinator: StoryContentCoordinator?
    let disposeBag = DisposeBag()
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
                return owner.storyListUseCase.fetchStoryListStream()
            }
            .asDriver(onErrorJustReturn: [])
            
        return Output(
            storyList: storyList
        )
    }
    
}
