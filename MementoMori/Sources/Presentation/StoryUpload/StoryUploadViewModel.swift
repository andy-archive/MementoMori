//
//  StoryUploadViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/7/23.
//

import UIKit

import RxCocoa
import RxSwift

final class StoryUploadViewModel: ViewModel {
    
    struct Input {
        let photoClickedInList: Observable<Void>
    }
    
    struct Output {
        
    }
    
    weak var coordinator: StoryUploadCoordinator?
    let disposeBag = DisposeBag()
//    private let storyUploadUseCase: StoryUploadUseCaseProtocol
    
    init(
        coordinator: StoryUploadCoordinator
//        storyUploadUseCase: StoryUploadUseCaseProtocol
    ) {
        self.coordinator = coordinator
//        self.storyUploadUseCase = storyUploadUseCase
    }
    
    func transform(input: Input) -> Output {
        
        
        
        return Output(
            
        )
    }
    
}
