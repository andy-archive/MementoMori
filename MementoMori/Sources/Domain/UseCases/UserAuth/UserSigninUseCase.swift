//
//  UserSigninUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxRelay

final class UserSigninUseCase: UserSigninUseCaseProtocol {
    
    private let userAuthRepository: UserAuthRepositoryProtocol
    
    let isEmailTextValid = PublishRelay<Bool>()
    let isPasswordTextValid = PublishRelay<Bool>()
    let isSigninButtonEnabled = BehaviorRelay(value: false)
    
    init(
        userAuthRepository: UserAuthRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
    }
}
