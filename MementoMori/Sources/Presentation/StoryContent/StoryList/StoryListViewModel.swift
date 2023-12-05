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
        let followingPeopleButtonClicked: ControlEvent<Void>
        let userFavoriteButtonCliked: ControlEvent<Void>
        let userProfileImageClicked: ControlEvent<Void>
        let storyEllipsisButtonClicked: ControlEvent<Void>
        let storyLikeButtonClicked: ControlEvent<Void>
        let commentButtonClicked: ControlEvent<Void>
        let shareButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let isLikedStory: PublishRelay<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let isLikedStory = PublishRelay<Bool>()
        
        return Output(
            isLikedStory: isLikedStory
        )
    }
    
}
