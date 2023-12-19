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
    
    //MARK: - Input
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let emailValidationButtonTap: ControlEvent<Void>
        let passwordSecureButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let isEmailTextValid: Signal<Bool>
        let isPasswordTextValid: Signal<Bool>
        let isNicknameTextValid: Signal<Bool>
        let emailValidationMessage: Driver<String>
        let isPasswordSecure: Driver<Bool>
        let isEmailValidationButtonEnabled: Driver<Bool>
        let isNextButtonEnabled: Driver<Bool>
        let joinResponse: Signal<APIResult<String>>
    }
    
    //MARK: - Properties
    weak var coordinator: AppCoordinator?
    private let userJoinUseCase: UserJoinUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer
    init(
        coordinator: AppCoordinator,
        userJoinUseCase: UserJoinUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.userJoinUseCase = userJoinUseCase
    }
    
    //MARK: - Transform Input into Output
    func transform(input: Input) -> Output {
        let isEmailTextValid = PublishRelay<Bool>()
        let isPasswordTextValid = PublishRelay<Bool>()
        let isNicknameTextValid = PublishRelay<Bool>()
        let emailValidationMessage = BehaviorRelay<String>(value: "")
        let isEmailValidationMessageValid = BehaviorRelay<Bool>(value: false)
        let requestedEmail = BehaviorRelay<String>(value: "")
        let isPasswordSecure = BehaviorRelay<Bool>(value: false)
        let isEmailValidationButtonEnabled = BehaviorRelay<Bool>(value: false)
        let isJoinButtonEnabled = BehaviorRelay<Bool>(value: false)
        let joinResponse = PublishRelay<APIResult<String>>()
        
        /// 가입 버튼 클릭 가능 여부에 대한 로직
        let checkJoinValidation: () -> Void =  {
            Observable.combineLatest(
                input.emailText,
                input.passwordText,
                input.nicknameText
            )
            .map { email, password, nickname in
                if isEmailValidationMessageValid.value &&
                    email.validateEmail() &&
                    password.validatePassword() &&
                    nickname.validateNickname() {
                    return true
                } else {
                    return false
                }
            }
            .subscribe(with: self) { owner, value in
                isJoinButtonEnabled.accept(value)
            }
            .dispose()
        }
        
        let joinInput = Observable.combineLatest(
            input.emailText,
            input.passwordText,
            input.nicknameText
        ) { email, password, nickname in
            User(email: email, password: password, nickname: nickname)
        }
            .share()
        
        input.emailText
            .subscribe(with: self) { owner, value in
                /// 이메일 검증 요청 이전
                if requestedEmail.value.isEmpty {
                    if !value.isEmpty && value.validateEmail() {
                        isEmailValidationButtonEnabled.accept(true)
                    } else {
                        isEmailValidationButtonEnabled.accept(false)
                    }
                } else { /// 이메일 검증 요청 이후
                    if !isEmailValidationMessageValid.value &&
                        value.validateEmail() {
                        isEmailValidationButtonEnabled.accept(true)
                    } else {
                        isEmailValidationButtonEnabled.accept(false)
                    }
                    
                    /// 이메일 검증 요청 성공 이후 다시 이메일을 바꿨을 때
                    if value != requestedEmail.value && isEmailValidationMessageValid.value {
                        emailValidationMessage.accept("이메일을 다시 입력하세요")
                        isEmailValidationMessageValid.accept(false)
                        isEmailTextValid.accept(false)
                        isEmailValidationButtonEnabled.accept(true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        /// 이메일 확인 버튼 클릭 시 네트워크 요청 (POST)
        input.emailValidationButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText) { _, emailText in
                requestedEmail.accept(emailText)
                return emailText
            }
            .withUnretained(self)
            .flatMap { owner, email in
                owner.userJoinUseCase.validate(email: email)
            }
            .bind(with: self) { owner, isEmailValid in
                if isEmailValid {
                    emailValidationMessage.accept(Constant.Text.Message.validEmail)
                    isEmailTextValid.accept(true)
                    isEmailValidationMessageValid.accept(true)
                    isEmailValidationButtonEnabled.accept(false)
                    checkJoinValidation() /// 이메일 검증 성공 시 가입 버튼을 누를 수 있는지 확인
                } else {
                    emailValidationMessage.accept(Constant.Text.Message.notValidEmail)
                    isEmailTextValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.passwordText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { _, passwordText in
                if !passwordText.isEmpty {
                    isPasswordTextValid.accept(passwordText.validatePassword())
                }
            }
            .disposed(by: disposeBag)
        
        input.nicknameText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { _, nicknameText in
                if !nicknameText.isEmpty {
                    isNicknameTextValid.accept(nicknameText.validateNickname())
                }
            }
            .disposed(by: disposeBag)
        
        input.passwordSecureButtonTap
            .subscribe(with: self) { _, _ in
                let result = !isPasswordSecure.value
                isPasswordSecure.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(joinInput)
            .withUnretained(self)
            .flatMap { owner, input in
                owner.userJoinUseCase.join(user: input)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .suceessData(let user):
                    joinResponse.accept(.suceessData(user.nickname ?? ""))
                    owner.coordinator?.signinModal.popViewController(animated: true) /// 회원 가입 성공 시 이전 화면으로 전환
                case .statusCode(let statusCode):
                    let message = UserJoinError(rawValue: statusCode)?.message ??
                    NetworkError(rawValue: statusCode)?.message ??
                    NetworkError.internalServerError.message
                    emailValidationMessage.accept(message)
                    isEmailTextValid.accept(false)
                    isPasswordTextValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailTextValid: isEmailTextValid.asSignal(),
            isPasswordTextValid: isPasswordTextValid.asSignal(),
            isNicknameTextValid: isNicknameTextValid.asSignal(),
            emailValidationMessage: emailValidationMessage.asDriver(),
            isPasswordSecure: isPasswordSecure.asDriver(),
            isEmailValidationButtonEnabled: isEmailValidationButtonEnabled.asDriver(),
            isNextButtonEnabled: isJoinButtonEnabled.asDriver(),
            joinResponse: joinResponse.asSignal()
        )
    }
}
