//
//  UserJoinViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/15.
//

import RxCocoa
import RxSwift

final class UserJoinViewModel: ViewModel {
    
    //MARK: - (1) Input
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let emailValidationButtonClicked: ControlEvent<Void>
        let passwordSecureButtonClicked: ControlEvent<Void>
        let nextButtonClicked: ControlEvent<Void>
    }
    
    //MARK: - (2) Output
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
    
    //MARK: - (3) Properties
    let disposeBag = DisposeBag()
    weak var coordinator: AppCoordinator?
    private let userJoinUseCase: UserJoinUseCaseProtocol
    private var requestedEmail = String()
    private var isEmailValidationMessageValid = false
    
    //MARK: - (4) Initializer
    init(
        coordinator: AppCoordinator,
        userJoinUseCase: UserJoinUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.userJoinUseCase = userJoinUseCase
    }
    
    //MARK: - (5) Protocol Method
    func transform(input: Input) -> Output {
        let checkJoinValidation: () -> Void =  {
            Observable
                .combineLatest(input.emailText, input.passwordText, input.nicknameText) { [weak self] email, password, nickname in
                    self?.isEmailValidationMessageValid ?? false &&
                    email.validateEmail() &&
                    password.validatePassword() &&
                    nickname.validateNickname()
                }
                .subscribe(with: self) { owner, value in
                    owner.userJoinUseCase.isNextButtonEnabled.accept(value)
                }
                .disposed(by: self.disposeBag)
        }
        
        let joinInput = Observable
            .combineLatest(input.emailText, input.passwordText, input.nicknameText) { email, password, nickname in
                User(email: email, password: password, nickname: nickname)
            }
            .share()
        
        input
            .emailText
            .subscribe(with: self) { owner, value in
                if owner.requestedEmail.isEmpty { // 이메일 검증 요청 이전
                    if !value.isEmpty && value.validateEmail() {
                        owner.userJoinUseCase.isEmailValidationButtonEnabled.accept(true)
                    } else {
                        owner.userJoinUseCase.isEmailValidationButtonEnabled.accept(false)
                    }
                } else { // 이메일 검증 요청 이후
                    if !owner.isEmailValidationMessageValid && value.validateEmail() {
                        owner.userJoinUseCase.isEmailValidationButtonEnabled.accept(true)
                    } else {
                        owner.userJoinUseCase.isEmailValidationButtonEnabled.accept(false)
                    }
                    
                    // 이메일 검증 요청 성공 이후 다시 이메일을 바꿨을 때
                    if value != owner.requestedEmail && owner.isEmailValidationMessageValid {
                        owner.userJoinUseCase.emailValidationMessage.accept("이메일을 다시 입력하세요")
                        owner.isEmailValidationMessageValid = false
                        owner.userJoinUseCase.isEmailTextValid.accept(false)
                        owner.userJoinUseCase.isEmailValidationButtonEnabled.accept(true)
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
            .subscribe(with: self) { owner, response in
                let message = response.message
                self.userJoinUseCase.emailValidationMessage.accept(message)
                
                if message == Constant.NetworkResponse.EmailValidation.Message.validEmail {
                    owner.isEmailValidationMessageValid = true
                    owner.userJoinUseCase.isEmailTextValid.accept(true)
                    owner.userJoinUseCase.isEmailValidationButtonEnabled.accept(false)
                    checkJoinValidation() // 성공 시 가입 버튼을 누를 수 있는지 검사
                } else {
                    owner.userJoinUseCase.isEmailTextValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, text in
                if !text.isEmpty {
                    owner.userJoinUseCase.isPasswordTextValid.accept(text.validatePassword())
                }
            }
            .disposed(by: disposeBag)
        
        input
            .nicknameText
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, text in
                if !text.isEmpty {
                    owner.userJoinUseCase.isNicknameTextValid.accept(text.validateNickname())
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordSecureButtonClicked
            .subscribe(with: self) { owner, _ in
                let value = owner.userJoinUseCase.isPasswordSecure.value
                owner.userJoinUseCase.isPasswordSecure.accept(!value)
            }
            .disposed(by: disposeBag)
        
        input
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(joinInput)
            .withUnretained(self)
            .flatMap { owner, input in
                owner.userJoinUseCase.join(user: input)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .suceessData(let user):
                    owner.userJoinUseCase.joinResponse.accept(.suceessData(user.nickname ?? ""))
                    owner.coordinator?.signinModal.popViewController(animated: true)
                case .statusCode(let statusCode):
                    let message = UserJoinError(rawValue: statusCode)?.message ??
                    NetworkError(rawValue: statusCode)?.message ??
                    NetworkError.internalServerError.message
                    owner.userJoinUseCase.emailValidationMessage.accept(message)
                    owner.userJoinUseCase.isEmailTextValid.accept(false)
                    owner.userJoinUseCase.isPasswordTextValid.accept(false)
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
