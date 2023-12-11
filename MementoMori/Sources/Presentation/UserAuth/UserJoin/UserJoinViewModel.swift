//
//  UserJoinViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/15.
//

import Foundation

import RxCocoa
import RxSwift

final class UserJoinViewModel: ViewModel {
    
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
        let joinResponse: PublishRelay<APIResult<String>>
    }
    
    weak var coordinator: UserAuthCoordinator?
    let disposeBag = DisposeBag()
    private let userJoinUseCase: UserJoinUseCaseProtocol
    
    private var requestedEmail = String()
    private var isEmailValidationMessageValid = false
    
    init(
        coordinator: UserAuthCoordinator,
        userJoinUseCase: UserJoinUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.userJoinUseCase = userJoinUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let checkJoinValidation: () -> Void =  {
            Observable
                .combineLatest(input.emailText, input.passwordText, input.nicknameText) { email, password, nickname in
                    self.isEmailValidationMessageValid &&
                    email.validateEmail() &&
                    password.validatePassword() &&
                    nickname.validateNickname()
                }
                .subscribe(with: self) { [weak self] _, value in
                    self?.userJoinUseCase.isNextButtonEnabled.accept(value)
                    self?.coordinator?.finish()
                }
                .disposed(by: self.disposeBag)
        }
        
        let joinInput = Observable
            .combineLatest(input.emailText, input.passwordText, input.nicknameText) { email, password, nickname in
                User(
                    id: nil,
                    email: email,
                    password: password,
                    nickname: nickname,
                    phoneNum: nil, 
                    birthday: nil,
                    accessToken: nil,
                    refreshToken: nil
                )
            }
            .share()
        
        input
            .emailText
            .subscribe(with: self) { [weak self] owner, value in
                if owner.requestedEmail.isEmpty { // 이메일 검증 요청 이전
                    if !value.isEmpty && value.validateEmail() {
                        self?.userJoinUseCase.isEmailValidationButtonEnabled.accept(true)
                    } else {
                        self?.userJoinUseCase.isEmailValidationButtonEnabled.accept(false)
                    }
                } else { // 이메일 검증 요청 이후
                    if !owner.isEmailValidationMessageValid && value.validateEmail() {
                        self?.userJoinUseCase.isEmailValidationButtonEnabled.accept(true)
                    } else {
                        self?.userJoinUseCase.isEmailValidationButtonEnabled.accept(false)
                    }
                    
                    // 이메일 검증 요청 성공 이후 다시 이메일을 바꿨을 때
                    if value != owner.requestedEmail && owner.isEmailValidationMessageValid {
                        self?.userJoinUseCase.emailValidationMessage.accept("이메일을 다시 입력하세요")
                        owner.isEmailValidationMessageValid = false
                        self?.userJoinUseCase.isEmailTextValid.accept(false)
                        self?.userJoinUseCase.isEmailValidationButtonEnabled.accept(true)
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
            .subscribe(with: self) { [weak self] _, response in
                let message = response.message
                self?.userJoinUseCase.emailValidationMessage.accept(message)
                
                if message == Constant.NetworkResponse.EmailValidation.Message.validEmail {
                    self?.isEmailValidationMessageValid = true
                    self?.userJoinUseCase.isEmailTextValid.accept(true)
                    self?.userJoinUseCase.isEmailValidationButtonEnabled.accept(false)
                    checkJoinValidation() // 성공 시 가입 버튼을 누를 수 있는지 검사
                } else {
                    self?.userJoinUseCase.isEmailTextValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { [weak self] _, text in
                if !text.isEmpty {
                    self?.userJoinUseCase.isPasswordTextValid.accept(text.validatePassword())
                }
            }
            .disposed(by: disposeBag)
        
        input
            .nicknameText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { [weak self] _, text in
                if !text.isEmpty {
                    self?.userJoinUseCase.isNicknameTextValid.accept(text.validateNickname())
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordSecureButtonClicked
            .subscribe(with: self) { [weak self] _, _ in
                guard let value = self?.userJoinUseCase.isPasswordSecure.value else { return }
                self?.userJoinUseCase.isPasswordSecure.accept(!value)
            }
            .disposed(by: disposeBag)
        
        input
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(joinInput)
            .flatMap { input in
                self.userJoinUseCase.join(user: input)
            }
            .bind(with: self) { [weak self] owner, result in
                switch result {
                case .suceessData(let user):
                    self?.userJoinUseCase.joinResponse.accept(.suceessData(user.nickname ?? ""))
                    self?.coordinator?.popViewController()
                case .errorStatusCode(let statusCode):
                    let message = UserJoinError(rawValue: statusCode)?.message ??
                    NetworkError(rawValue: statusCode)?.message ??
                    NetworkError.internalServerError.message
                    self?.userJoinUseCase.emailValidationMessage.accept(message)
                    self?.userJoinUseCase.isEmailTextValid.accept(false)
                    self?.userJoinUseCase.isPasswordTextValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailTextValid: userJoinUseCase.isEmailTextValid,
            isPasswordTextValid: self.userJoinUseCase.isPasswordTextValid,
            isNicknameTextValid: self.userJoinUseCase.isNicknameTextValid,
            emailValidationMessage: self.userJoinUseCase.emailValidationMessage,
            isPasswordSecure: self.userJoinUseCase.isPasswordSecure,
            isEmailValidationButtonEnabled: self.userJoinUseCase.isEmailValidationButtonEnabled,
            isNextButtonEnabled: self.userJoinUseCase.isNextButtonEnabled,
            joinResponse: self.userJoinUseCase.joinResponse
        )
    }
}
