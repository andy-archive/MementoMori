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
    
    func signin(user: User) -> Single<APIResult<Authorization>> {
        self.userAuthRepository.signin(user: user)
    }
    
    func verifySigninProcess(response: APIResult<Authorization>) -> (isCompleted: Bool, message: String) {
        switch response {
        case .suceessData(let authData):
            return isAllTokenSaved(authData: authData) ?
            (true, "환영합니다 😆") : (false, TokenError.invalidToken.message)
        case .errorStatusCode(let stausCode):
            return (false, verifyErrorMessage(statusCode: stausCode))
        }
    }
    
    private func isAllTokenSaved(authData: Authorization) -> Bool {
        let isTokenSaved = keychainRepository
            .save(
                key: .token,
                value: authData.accesstoken
            )
        
        let isRefreshTokenSaved = keychainRepository
            .save(
                key: .refreshToken,
                value: authData.refreshToken
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
