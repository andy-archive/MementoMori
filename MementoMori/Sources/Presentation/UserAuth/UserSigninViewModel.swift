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
    }
    
    struct Output {
        let isEmailTextValid: PublishRelay<Bool>
        let isPasswordTextValid: PublishRelay<Bool>
        let isSigninButtonEnabled: BehaviorRelay<Bool>
    }
    
    weak var coordinator: AppCoordinator?
    private let userJoinUseCase: UserJoinUseCaseProtocol
    private var requestedEmail = String()
    private var isEmailValidationMessageValid = false
    var disposeBag = DisposeBag()
    
    init(
        coordinator: AppCoordinator,
        userJoinUseCase: UserJoinUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.userJoinUseCase = userJoinUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let isEmailTextValid = PublishRelay<Bool>()
        let isPasswordTextValid = PublishRelay<Bool>()
        let isSigninButtonEnabled = BehaviorRelay(value: false)
        
        Observable
            .combineLatest(input.emailText, input.passwordText) { email, password in
                email.validateEmail() && password.validatePassword()
            }
            .subscribe(with: self) { _, value in
                isSigninButtonEnabled.accept(value)
            }
            .disposed(by: self.disposeBag)
        
        input
            .emailText
            .subscribe(with: self) { owner, value in
                if !value.isEmpty {
                    isEmailTextValid.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .passwordText
            .subscribe(with: self) { owner, value in
                if !value.isEmpty {
                    isPasswordTextValid.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isEmailTextValid: isEmailTextValid,
            isPasswordTextValid: isPasswordTextValid,
            isSigninButtonEnabled: isSigninButtonEnabled
        )
    }
}
