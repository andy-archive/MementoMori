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
    private let keychainManager: KeychainManager
    
    let isEmailTextValid = PublishRelay<Bool>()
    let isPasswordTextValid = PublishRelay<Bool>()
    let isSigninButtonEnabled = BehaviorRelay(value: false)
    let isSigninCompleted = PublishRelay<Bool>()
    let errorMessage = PublishRelay<String>()
    
    init(
        userAuthRepository: UserAuthRepositoryProtocol,
        keychainManager: KeychainManager
    ) {
        self.userAuthRepository = userAuthRepository
        self.keychainManager = keychainManager
    }
    
    func signin(userInfo: User) -> Single<NetworkResult<Void>> {
        self.userAuthRepository
            .signin(userInfo: userInfo)
            .flatMap { result in
                switch result {
                case .success(let data):
                    return self.isTokenSaved(authData: data) ?
                    Single<NetworkResult>.just(.success(())) :
                    Single<NetworkResult>.just(.failure(TokenError.invalidToken))
                case .failure(_):
                    return Single<NetworkResult>.just(.failure(UserSigninError.badRequest))}
            }
    }
    
    func isTokenSaved(authData: Authorization) -> Bool {
        let isTokenSaved = keychainManager
            .save(
                key: .token,
                value: authData.token
            )
        
        let isRefreshTokenSaved = keychainManager
            .save(
                key: .refreshToken,
                value: authData.refreshToken
            )
        
        if isTokenSaved && isRefreshTokenSaved {
            return true
        }
        
        return false
    }
    
}
