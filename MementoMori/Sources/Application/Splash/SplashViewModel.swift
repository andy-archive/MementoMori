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
    let disposeBag = DisposeBag()
    weak var coordinator: AppCoordinator?
    private let userSigninUseCase: UserSigninUseCaseProtocol
    
    //MARK: - Initializer
    init(
        coordinator: AppCoordinator,
        userSigninUseCase: UserSigninUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.userSigninUseCase = userSigninUseCase
    }
    
    //MARK: - Protocol Methods
    func transform(input: Input) -> Output {
        return Output()
    }
}
