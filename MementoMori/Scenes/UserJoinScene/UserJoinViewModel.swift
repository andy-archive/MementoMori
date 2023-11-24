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
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let emailValidationButtonClicked: ControlEvent<Void>
        let passwordSecureButtonClicked: ControlEvent<Void>
        let nextButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailTextValid: PublishRelay<Bool>
        let isPasswordTextValid: PublishRelay<Bool>
        let isNicknameTextValid: PublishRelay<Bool>
        let emailValidationMessage: BehaviorRelay<String>
        let isPasswordSecure: BehaviorRelay<Bool>
        let isEmailValidationButtonEnabled: BehaviorRelay<Bool>
        let isNextButtonEnabled: Observable<Bool>
    }
    
    private var requestedEmail = String()
    private var isEmailValidationMessageValid = false
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let isEmailTextValid = PublishRelay<Bool>()
        let isPasswordTextValid = PublishRelay<Bool>()
        let isNicknameTextValid = PublishRelay<Bool>()
        let emailValidationMessage = BehaviorRelay(value: String())
        let isPasswordSecure = BehaviorRelay(value: false)
        let isEmailValidationButtonEnabled = BehaviorRelay(value: false)
        
        let isNextButtonEnabled = Observable
            .combineLatest(input.emailText, input.passwordText, input.nicknameText) { email, password, nickname in
                self.isEmailValidationMessageValid && password.validatePassword() && nickname.validateNickname()
            }
        
        input
            .emailText
            .subscribe(with: self) { owner, value in
                if !value.isEmpty && value.validateEmail()  {
                    isEmailValidationButtonEnabled.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .emailText
            .subscribe(with: self) { owner, value in
                if (owner.isEmailValidationMessageValid &&
                    isEmailValidationButtonEnabled.value &&
                     value != owner.requestedEmail) {
                    isEmailTextValid.accept(false)
                    emailValidationMessage.accept("이메일을 다시 입력하세요")
                    owner.isEmailValidationMessageValid = false
                }
            }
            .disposed(by: disposeBag)
        
        input
            .emailValidationButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText) { _, query in
                self.requestedEmail = query
                return query
            }
            .flatMap { query in
                APIManager.shared.validateEmail(email: query)
            }
            .subscribe(with: self) { _, response in
                let message = response.message
                emailValidationMessage.accept(message)
                
                if message == Constant.NetworkResponse.EmailValidation.Message.validEmail {
                    self.isEmailValidationMessageValid = true
                    isEmailTextValid.accept(true)
                    isEmailValidationButtonEnabled.accept(false)
                } else {
                    isEmailTextValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { _, text in
                if !text.isEmpty {
                    isPasswordTextValid.accept(text.validatePassword())
                }
            }
            .disposed(by: disposeBag)
        
        input
            .nicknameText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { _, text in
                if !text.isEmpty {
                    isNicknameTextValid.accept(text.validateNickname())
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordSecureButtonClicked
            .subscribe(with: self) { _, _ in
                isPasswordSecure.accept(!isPasswordSecure.value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailTextValid: isEmailTextValid,
            isPasswordTextValid: isPasswordTextValid,
            isNicknameTextValid: isNicknameTextValid,
            emailValidationMessage: emailValidationMessage,
            isPasswordSecure: isPasswordSecure,
            isEmailValidationButtonEnabled: isEmailValidationButtonEnabled,
            isNextButtonEnabled: isNextButtonEnabled
        )
    }
}
