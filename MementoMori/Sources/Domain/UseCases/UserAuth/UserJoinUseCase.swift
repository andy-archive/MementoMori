//
//  UserJoinUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxRelay
import RxSwift

final class UserJoinUseCase: UserJoinUseCaseProtocol {
    
    //MARK: - (1) Properties
    private let userAuthRepository: UserAuthRepositoryProtocol
    var isEmailTextValid = PublishRelay<Bool>()
    var isPasswordTextValid = PublishRelay<Bool>()
    var isNicknameTextValid = PublishRelay<Bool>()
    var emailValidationMessage = BehaviorRelay<String>(value: "")
    var isPasswordSecure = BehaviorRelay<Bool>(value: true)
    var isEmailValidationButtonEnabled = BehaviorRelay<Bool>(value: false)
    var isJoinButtonEnabled = BehaviorRelay<Bool>(value: false)
    var joinResponse = PublishRelay<APIResult<String>>()
    
    //MARK: - (2) Initializer
    init(
        userAuthRepository: UserAuthRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
    }
    
    //MARK: - (3) Protocol Method
    func join(user: User) -> Single<APIResult<User>> {
        return self.userAuthRepository.join(user: user)
    }
}
