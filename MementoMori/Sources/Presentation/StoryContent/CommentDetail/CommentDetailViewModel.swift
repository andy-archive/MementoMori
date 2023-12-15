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
    weak var coordinator: Coordinator?
//    private let myuseCase: MyUseCaseProtocol
    
    //MARK: - Initializer
    init(
        coordinator: Coordinator
//        myuseCase: MyUseCaseProtocol
    ) {
        self.coordinator = coordinator
//        self.myuseCase = myuseCase
    }
    
    //MARK: - Transform from Input to Output
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
