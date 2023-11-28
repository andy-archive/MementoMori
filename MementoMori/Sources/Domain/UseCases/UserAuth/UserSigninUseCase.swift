//
//  UserSigninUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxRelay
import RxSwift

final class UserSigninUseCase: UserSigninUseCaseProtocol {
    
    private let userAuthRepository: UserAuthRepositoryProtocol
    
    let isEmailTextValid = PublishRelay<Bool>()
    let isPasswordTextValid = PublishRelay<Bool>()
    let isSigninButtonEnabled = BehaviorRelay(value: false)
    let signinResponse = PublishRelay<NetworkResult<Void>>()
    
    init(
        userAuthRepository: UserAuthRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
    }
    
    func signin(userInfo: User) -> Single<NetworkResult<Authorization>> {
        return self.userAuthRepository.signin(userInfo: userInfo)
    }
}
