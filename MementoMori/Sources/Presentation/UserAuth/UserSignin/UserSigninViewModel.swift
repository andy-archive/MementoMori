//
//  UserSigninViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import Foundation

import RxCocoa
import RxSwift

final class UserSigninViewModel: ViewModel {
    
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let signinButtonClicked: ControlEvent<Void>
        let joinButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailTextValid: PublishRelay<Bool>
        let isPasswordTextValid: PublishRelay<Bool>
        let isSigninButtonEnabled: BehaviorRelay<Bool>
        let isSigninProcessValid: PublishRelay<Bool>
        let signinValidationText: PublishRelay<String>
    }
    
    weak var coordinator: AppCoordinator?
    let disposeBag = DisposeBag()
    private let userSigninUseCase: UserSigninUseCaseProtocol
    
    init(
        coordinator: AppCoordinator,
        userSigninUseCase: UserSigninUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.userSigninUseCase = userSigninUseCase
    }
    
    func transform(input: Input) -> Output {
        
        Observable
            .combineLatest(input.emailText, input.passwordText) { email, password in
                email.validateEmail() && password.validatePassword()
            }
            .subscribe(with: self) { [weak self] _, value in
                self?.userSigninUseCase.isSigninButtonEnabled.accept(value)
            }
            .disposed(by: self.disposeBag)
        
        let userInfo = Observable
            .combineLatest(input.emailText, input.passwordText) { email, password in
                User(
                    email: email,
                    password: password,
                    nick: nil,
                    phoneNum: nil,
                    birthday: nil
                )
            }
        
        input
            .emailText
            .subscribe(with: self) { [weak self] owner, value in
                if !value.isEmpty {
                    self?.userSigninUseCase.isEmailTextValid.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordText
            .subscribe(with: self) { [weak self] owner, value in
                if !value.isEmpty {
                    self?.userSigninUseCase.isPasswordTextValid.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .signinButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(userInfo)
            .flatMap { user in
                self.userSigninUseCase.signin(user: user)
            }
            .bind(with: self) { owner, result in
                let signinProcess = self.userSigninUseCase.verifySigninProcess(response: result)
                if signinProcess.isCompleted {
                    self.coordinator?.showTabBarFlow()
                } else {
                    self.userSigninUseCase.isSigninCompleted.accept(signinProcess.isCompleted)
                    self.userSigninUseCase.errorMessage.accept(signinProcess.message)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .joinButtonClicked
            .subscribe(with: self) { owner, _ in
                owner.coordinator?.showUserJoinViewController()
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailTextValid: userSigninUseCase.isEmailTextValid,
            isPasswordTextValid: userSigninUseCase.isPasswordTextValid,
            isSigninButtonEnabled: userSigninUseCase.isSigninButtonEnabled,
            isSigninProcessValid: self.userSigninUseCase.isSigninCompleted,
            signinValidationText: self.userSigninUseCase.errorMessage
        )
    }
}
