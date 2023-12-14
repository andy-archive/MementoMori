//
//  SplashViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/14/23.
//

import UIKit

import RxSwift

final class SplashViewModel: ViewModel {
    
    struct Input { }
    struct Output { }
    
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
        return Output()
    }
}
