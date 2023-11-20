//
//  UserJoinViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/15.
//

import Foundation

import RxCocoa
import RxSwift

final class UserJoinViewModel: ViewModelType {
    
    struct Input {
        let text: ControlProperty<String>
        let nextButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let isTextValid: Observable<Bool>
        let responseMessage: BehaviorRelay<String>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let validationMessage = BehaviorRelay(value: String())
        
        let isTextValid = input
            .text
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.validateEmail() }
        
        input
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.text) { _, query in
                return query
            }
            .flatMap { query in
                APIManager.shared.validateEmail(email: query)
            }
            .subscribe(with: self) { owner, response in
                validationMessage.accept(response.message)
            }
            .disposed(by: disposeBag)
        
        return Output(isTextValid: isTextValid, responseMessage: validationMessage)
    }
}
