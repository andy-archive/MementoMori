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
    
    //MARK: - Input
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let signinButtonClicked: ControlEvent<Void>
        let joinButtonClicked: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let isEmailTextValid: PublishRelay<Bool>
        let isPasswordTextValid: PublishRelay<Bool>
        let isSigninButtonEnabled: BehaviorRelay<Bool>
        let isSigninProcessValid: PublishRelay<Bool>
        let signinValidationText: PublishRelay<String>
    }
    
    //MARK: - Properties
    weak var coordinator: AppCoordinator?
    private let userSigninUseCase: UserSigninUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer
    init(
        coordinator: AppCoordinator,
        userSigninUseCase: UserSigninUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.userSigninUseCase = userSigninUseCase
    }
    
    //MARK: - Transform Input into Output
    func transform(input: Input) -> Output {
        let isEmailTextValid = PublishRelay<Bool>()
        let isPasswordTextValid = PublishRelay<Bool>()
        let isSigninButtonEnabled = BehaviorRelay(value: false)
        let isSigninCompleted = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        
        let userInfo = Observable.combineLatest(
            input.emailText,
            input.passwordText
        ) { email, password in
            User(email: email, password: password)
        }
        
        Observable.combineLatest(
            input.emailText,
            input.passwordText
        ) { email, password in
            email.validateEmail() && password.validatePassword()
        }
        .subscribe(with: self) { _, value in
            isSigninButtonEnabled.accept(value)
        }
        .disposed(by: self.disposeBag)
        
        input.emailText
            .bind(with: self) { owner, value in
                if !value.isEmpty {
                    isEmailTextValid.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.passwordText
            .bind(with: self) { owner, value in
                if !value.isEmpty { isPasswordTextValid.accept(true) }
            }
            .disposed(by: disposeBag)
        
        input.signinButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(userInfo)
            .withUnretained(self)
            .flatMap { owner, user in
                owner.userSigninUseCase.signin(user: user)
            }
            .bind(with: self) { owner, result in
                let authentication = owner.userSigninUseCase.authenticate(result: result)
                if authentication.isAuthorized {
                    owner.coordinator?.dismissViewController()
                } else {
                    isSigninCompleted.accept(authentication.isAuthorized)
                    errorMessage.accept(authentication.message)
                }
            }
            .disposed(by: disposeBag)
        
        input.joinButtonClicked
            .bind(with: self) { owner, _ in
                owner.coordinator?.showUserJoinViewController()
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailTextValid: isEmailTextValid,
            isPasswordTextValid: isPasswordTextValid,
            isSigninButtonEnabled: isSigninButtonEnabled,
            isSigninProcessValid: isSigninCompleted,
            signinValidationText: errorMessage
        )
    }
}
