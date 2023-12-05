//
//  UserSigninUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxSwift

final class UserSigninUseCase: UserSigninUseCaseProtocol {
    
    private let userAuthRepository: UserAuthRepositoryProtocol
    private let keychainRepository: KeychainRepositoryProtocol
    
    init(
        userAuthRepository: UserAuthRepositoryProtocol,
        keychainRepository: KeychainRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
        self.keychainRepository = keychainRepository
    }
    
    func signin(user: User) -> Single<APIResult<User>> {
        self.userAuthRepository.signin(user: user)
    }
    
    func verifySigninProcess(response: APIResult<User>) -> (isCompleted: Bool, message: String) {
        switch response {
        case .suceessData(let user):
            return isAllTokenSaved(user: user) ?
            (true, "환영합니다 😆") : (false, TokenError.invalidToken.message)
        case .errorStatusCode(let statusCode):
            return (false, verifyErrorMessage(statusCode: statusCode))
        }
    }
    
    private func isAllTokenSaved(user: User) -> Bool {
        guard let userId = user.id,
              let accessToken = user.accessToken,
              let refreshToken = user.refreshToken
        else { return false }
        
        let isTokenSaved = keychainRepository
            .save(
                key: userId,
                value: accessToken,
                type: .accessToken
            )
        
        let isRefreshTokenSaved = keychainRepository
            .save(
                key: userId,
                value: refreshToken,
                type: .refreshToken
            )
        
        if isTokenSaved && isRefreshTokenSaved {
            return true
        }
        
        return false
    }
    
    private func verifyErrorMessage(statusCode: Int) -> String {
        return UserSigninError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
    }
}
