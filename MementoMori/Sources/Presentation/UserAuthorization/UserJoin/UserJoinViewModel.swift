//
//  UserJoinViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/15.
//

import RxCocoa
import RxSwift

final class UserJoinViewModel: ViewModel {
    
    //MARK: - Input
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let emailValidationButtonClicked: ControlEvent<Void>
        let passwordSecureButtonClicked: ControlEvent<Void>
        let nextButtonClicked: ControlEvent<Void>
    }
    
    //MARK: - Output
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
    
    //MARK: - Properties
    weak var coordinator: AppCoordinator?
    private let userJoinUseCase: UserJoinUseCaseProtocol
    private let disposeBag = DisposeBag()
    private var requestedEmail = String()
    private var isEmailValidationMessageValid = false
    
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
        var isEmailTextValid = PublishRelay<Bool>()
        var isPasswordTextValid = PublishRelay<Bool>()
        var isNicknameTextValid = PublishRelay<Bool>()
        var emailValidationMessage = BehaviorRelay<String>(value: "")
        var isPasswordSecure = BehaviorRelay<Bool>(value: false)
        var isEmailValidationButtonEnabled = BehaviorRelay<Bool>(value: false)
        var isJoinButtonEnabled = BehaviorRelay<Bool>(value: false)
        var joinResponse = PublishRelay<APIResult<String>>()
        
        /// 가입 버튼 클릭 가능 여부에 대한 로직
        let checkJoinValidation: () -> Void =  {
            Observable.combineLatest(
                input.emailText,
                input.passwordText,
                input.nicknameText
            )
            .map { [weak self] email, password, nickname in
                guard let self else { return false }
                
                if self.isEmailValidationMessageValid && email.validateEmail() &&
                    password.validatePassword() && nickname.validateNickname() {
                    return true
                } else {
                    return false
                }
            }
            .subscribe(with: self) { owner, value in
                isJoinButtonEnabled.accept(value)
            }
            .disposed(by: self.disposeBag)
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
                if owner.requestedEmail.isEmpty { /// 이메일 검증 요청 이전
                    if !value.isEmpty && value.validateEmail() {
                        isEmailValidationButtonEnabled.accept(true)
                    } else {
                        isEmailValidationButtonEnabled.accept(false)
                    }
                } else { /// 이메일 검증 요청 이후
                    if !owner.isEmailValidationMessageValid && value.validateEmail() {
                        isEmailValidationButtonEnabled.accept(true)
                    } else {
                        isEmailValidationButtonEnabled.accept(false)
                    }
                    
                    /// 이메일 검증 요청 성공 이후 다시 이메일을 바꿨을 때
                    if value != owner.requestedEmail && owner.isEmailValidationMessageValid {
                        owner.isEmailValidationMessageValid = false
                        emailValidationMessage.accept("이메일을 다시 입력하세요")
                        isEmailTextValid.accept(false)
                        isEmailValidationButtonEnabled.accept(true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.emailValidationButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText) { [weak self] _, query in
                self?.requestedEmail = query
                return query
            }
            .flatMap { query in
                APIManager.shared.validateEmail(email: query)
            }
            .subscribe(with: self) { owner, response in
                let message = response.message
                emailValidationMessage.accept(message)
                
                if message == Constant.NetworkResponse.EmailValidation.Message.validEmail {
                    owner.isEmailValidationMessageValid = true
                    isEmailTextValid.accept(true)
                    isEmailValidationButtonEnabled.accept(false)
                    checkJoinValidation() /// 이메일 검증 성공 시 가입 버튼을 누를 수 있는지 확인
                } else {
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
        
        input.passwordSecureButtonClicked
            .subscribe(with: self) { _, _ in
                let result = !isPasswordSecure.value
                isPasswordSecure.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonClicked
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
                    owner.coordinator?.signinModal.popViewController(animated: true) /// 회원 가입 성공 시 이전 화면 돌아 가기
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
            isEmailTextValid: isEmailTextValid,
            isPasswordTextValid: isPasswordTextValid,
            isNicknameTextValid: isNicknameTextValid,
            emailValidationMessage: emailValidationMessage,
            isPasswordSecure: isPasswordSecure,
            isEmailValidationButtonEnabled: isEmailValidationButtonEnabled,
            isNextButtonEnabled: isJoinButtonEnabled,
            joinResponse: joinResponse
        )
    }
}
