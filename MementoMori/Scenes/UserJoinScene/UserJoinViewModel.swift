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
        let emailText: ControlProperty<String>
        let emailValidationButtonClicked: ControlEvent<Void>
        let passwordText: ControlProperty<String>
        let passwordSecureButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailTextValid: Observable<Bool>
        let responseMessage: BehaviorRelay<String>
        let isPasswordTextValid: Observable<Bool>
        let isPasswordSecure: BehaviorRelay<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let validationMessage = BehaviorRelay(value: String())
        let passwordValidationLabel = BehaviorRelay(value: String())
        let isPasswordTextValid = PublishRelay<Bool>()
        let isPasswordSecure = BehaviorRelay(value: false)
        
        let isTextValid = input
            .emailText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.validateEmail() }
        
        input
            .emailValidationButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText) { _, query in
                return query
            }
            .flatMap { query in
                APIManager.shared.validateEmail(email: query)
            }
            .subscribe(with: self) { _, response in
                validationMessage.accept(response.message)
            }
            .disposed(by: disposeBag)
        
        let isPasswordValid = input
            .passwordText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.validatePassword() }
        
        input
            .passwordSecureButtonClicked
            .subscribe(with: self) { _, _ in
                isPasswordSecure.accept(!isPasswordSecure.value)
            }
            .disposed(by: disposeBag)
        
        return Output(isEmailTextValid: isTextValid, responseMessage: validationMessage, isPasswordTextValid: isPasswordValid, isPasswordSecure: isPasswordSecure)
    }
}
