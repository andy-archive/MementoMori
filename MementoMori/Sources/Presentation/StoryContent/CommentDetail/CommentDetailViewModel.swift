//
//  CommentDetailViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import Foundation

import RxSwift

final class CommentDetailViewModel: ViewModel {
    
    //MARK: - Input
    struct Input { }
    
    //MARK: - Output
    struct Output { }
    
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
        
        
        return Output()
    }
}
