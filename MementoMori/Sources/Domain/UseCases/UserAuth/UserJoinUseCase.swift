//
//  UserJoinUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxRelay
import RxSwift

final class UserJoinUseCase: UserJoinUseCaseProtocol {
    
    private let userAuthRepository: UserAuthRepositoryProtocol
    
    var isEmailTextValid = PublishRelay<Bool>()
    var isPasswordTextValid = PublishRelay<Bool>()
    var isNicknameTextValid = PublishRelay<Bool>()
    var emailValidationMessage = BehaviorRelay<String>(value: "")
    var isPasswordSecure = BehaviorRelay<Bool>(value: true)
    var isEmailValidationButtonEnabled = BehaviorRelay<Bool>(value: false)
    var isNextButtonEnabled = BehaviorRelay<Bool>(value: false)
    var joinResponse = PublishRelay<APIResult<String>>()
    
    init(
        userAuthRepository: UserAuthRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
    }
    
    func join(user: User) -> Single<APIResult<User>> {
        return self.userAuthRepository.join(user: user)
    }
}
