//
//  SplashViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/14/23.
//

import RxSwift

final class SplashViewModel: ViewModel {
    
    //MARK: - Input
    struct Input { }
    
    //MARK: - Output
    struct Output { }
    
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
        return Output()
    }
    
    //MARK: - Check Auto Signin
    func startAutoSigninStream() {
        userSigninUseCase.checkAutoSignin()
            .subscribe(with: self) { owner, isAuthorized in
                if isAuthorized {
                    owner.coordinator?.showTabBarController()
                } else {
                    owner.coordinator?.connectSigninModal()
                    owner.coordinator?.showUserSigninViewController()
                }
            }
            .disposed(by: disposeBag)
    }
}
