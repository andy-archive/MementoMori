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
//        let followingPeopleButtonClicked: ControlEvent<Void>
//        let userFavoriteButtonCliked: ControlEvent<Void>
//        let userProfileImageClicked: ControlEvent<Void>
//        let storyEllipsisButtonClicked: ControlEvent<Void>
//        let storyLikeButtonClicked: ControlEvent<Void>
//        let commentButtonClicked: ControlEvent<Void>
//        let shareButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let postList: BehaviorSubject<[StoryPost]>
        let userNickname: PublishRelay<String>
        let storyContent: PublishRelay<String>
        let isLikedStory: BehaviorRelay<Bool>
        let isSavedStory: BehaviorRelay<Bool>
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
        let postList = BehaviorSubject<[StoryPost]>(value: MockData().postList)
        let userNickname = PublishRelay<String>()
        let storyContent = PublishRelay<String>()
        let isLikedStory = BehaviorRelay<Bool>(value: false)
        let isSavedStory = BehaviorRelay<Bool>(value: false)
        
        return Output(
            postList: postList,
            userNickname: userNickname,
            storyContent: storyContent,
            isLikedStory: isLikedStory,
            isSavedStory: isSavedStory
        )
    }
    
}
