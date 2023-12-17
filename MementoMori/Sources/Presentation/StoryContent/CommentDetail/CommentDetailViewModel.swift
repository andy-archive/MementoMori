//
//  CommentDetailViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import Foundation

import RxCocoa
import RxSwift

final class CommentDetailViewModel: ViewModel {
    
    //MARK: - Input
    struct Input {
        let commentTextToUpload: ControlProperty<String>
    }
    
    //MARK: - Output
    struct Output {
        let isCommentValid: Driver<Bool>
    }
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    weak var coordinator: StoryContentCoordinator?
    private let commentUseCase: CommentUseCaseProtocol
    
    //MARK: - Initializer
    init(
        coordinator: StoryContentCoordinator,
        commentUseCase: CommentUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.commentUseCase = commentUseCase
    }
    
    //MARK: - Transform from Input to Output
    func transform(input: Input) -> Output {
        
        let commentValidation = BehaviorRelay(value: false)
        
        input.commentTextToUpload
            .withUnretained(self)
            .map { owner, text in
                !text.isEmpty
            }
            .bind(with: self) { owner, isTextValid in
                commentValidation.accept(isTextValid)
            }
            .disposed(by: disposeBag)
        
        return Output(
            isCommentValid: commentValidation.asDriver()
        )
    }
}
