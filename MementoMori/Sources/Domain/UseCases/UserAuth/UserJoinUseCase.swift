//
//  UserJoinUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxRelay
import RxSwift

final class UserJoinUseCase: UserJoinUseCaseProtocol {
    
    var userAuthRepository: UserAuthRepositoryProtocol
    
    var isEmailTextValid = PublishRelay<Bool>()
    var isPasswordTextValid = PublishRelay<Bool>()
    var isNicknameTextValid = PublishRelay<Bool>()
    var emailValidationMessage = BehaviorRelay<String>(value: "")
    var isPasswordSecure = BehaviorRelay<Bool>(value: true)
    var isEmailValidationButtonEnabled = BehaviorRelay<Bool>(value: false)
    var isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    var joinResponse: PublishRelay<NetworkResult<String>>
    
    init(
        userAuthRepository: UserAuthRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
    }
    
    func join(userInfo: User) -> Single<NetworkResult<User>> {
        return self.userAuthRepository.join(userInfo: userInfo)
    }
}
