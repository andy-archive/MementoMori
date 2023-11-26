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
        let isNextButtonEnabled: BehaviorRelay<Bool>
        let joinResponse: PublishRelay<Result<Void>>
    }
    
    private var requestedEmail = String()
    private var isEmailValidationMessageValid = false
    private let userAuthRepository: AuthRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(userAuthRepository: AuthRepositoryProtocol) {
        self.userAuthRepository = userAuthRepository
    }
    
    func transform(input: Input) -> Output {
        
        let isEmailTextValid = PublishRelay<Bool>()
        let isPasswordTextValid = PublishRelay<Bool>()
        let isNicknameTextValid = PublishRelay<Bool>()
        let emailValidationMessage = BehaviorRelay(value: String())
        let isPasswordSecure = BehaviorRelay(value: false)
        let isEmailValidationButtonEnabled = BehaviorRelay(value: false)
        let isNextButtonEnabled = BehaviorRelay(value: false)
        let joinResponse = PublishRelay<Result<Void>>()
        
        let checkJoinValidation: () -> Void =  {
            Observable
                .combineLatest(input.emailText, input.passwordText, input.nicknameText) { email, password, nickname in
                    self.isEmailValidationMessageValid &&
                    email.validateEmail() &&
                    password.validatePassword() &&
                    nickname.validateNickname()
                }
                .subscribe(with: self) { _, value in
                    isNextButtonEnabled.accept(value)
                }
                .disposed(by: self.disposeBag)
        }
        
        let joinInput = Observable
            .combineLatest(input.emailText, input.passwordText, input.nicknameText) { email, password, nickname in
                UserJoinRequest(email: email, password: password, nick: nickname, phoneNum: nil, birthday: nil)
            }
            .share()
        
        input
            .emailText
            .subscribe(with: self) { owner, value in
                if owner.requestedEmail.isEmpty { // 이메일 검증 요청 이전
                    if !value.isEmpty && value.validateEmail() {
                        isEmailValidationButtonEnabled.accept(true)
                    } else {
                        isEmailValidationButtonEnabled.accept(false)
                    }
                } else { // 이메일 검증 요청 이후
                    if !owner.isEmailValidationMessageValid && value.validateEmail() {
                        isEmailValidationButtonEnabled.accept(true)
                    } else {
                        isEmailValidationButtonEnabled.accept(false)
                    }
                    
                    // 이메일 검증 요청 성공 이후 다시 이메일을 바꿨을 때
                    if value != owner.requestedEmail && owner.isEmailValidationMessageValid {
                        emailValidationMessage.accept("이메일을 다시 입력하세요")
                        owner.isEmailValidationMessageValid = false
                        isEmailTextValid.accept(false)
                        isEmailValidationButtonEnabled.accept(true)
                    }
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
                    checkJoinValidation() // 성공 시 가입 버튼을 누를 수 있는지 검사
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
        
        input
            .nextButtonClicked
            .debug()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(joinInput)
            .flatMap { input in
                self.userAuthRepository.join(userInfo: input)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    joinResponse.accept(.success(response))
                case .failure(let error):
                    joinResponse.accept(.failure(error))
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailTextValid: isEmailTextValid,
            isPasswordTextValid: isPasswordTextValid,
            isNicknameTextValid: isNicknameTextValid,
            emailValidationMessage: emailValidationMessage,
            isPasswordSecure: isPasswordSecure,
            isEmailValidationButtonEnabled: isEmailValidationButtonEnabled,
            isNextButtonEnabled: isNextButtonEnabled,
            joinResponse: joinResponse
        )
    }
}
