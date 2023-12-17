//
//  UserJoinUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import Foundation

import RxSwift

final class UserJoinUseCase: UserJoinUseCaseProtocol {
    
    //MARK: - Properties
    private let userAuthRepository: UserAuthRepositoryProtocol
    
    //MARK: - Initializer
    init(
        userAuthRepository: UserAuthRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
    }
    
    //MARK: - Protocol Method
    func join(user: User) -> Single<APIResult<User>> {
        return self.userAuthRepository.join(user: user)
    }
}
