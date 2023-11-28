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
    private let userSigninUseCase: UserSigninUseCaseProtocol
    var disposeBag = DisposeBag()
    
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
        
        return Output(
            isEmailTextValid: userSigninUseCase.isEmailTextValid,
            isPasswordTextValid: userSigninUseCase.isPasswordTextValid,
            isSigninButtonEnabled: userSigninUseCase.isSigninButtonEnabled
        )
    }
}
