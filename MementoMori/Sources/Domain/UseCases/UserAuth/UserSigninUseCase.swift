//
//  UserSigninUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxSwift

final class UserSigninUseCase: UserSigninUseCaseProtocol {
    
    private let userAuthRepository: UserAuthRepositoryProtocol
    private let keychainManager: KeychainManager
    
    init(
        userAuthRepository: UserAuthRepositoryProtocol,
        keychainManager: KeychainManager
    ) {
        self.userAuthRepository = userAuthRepository
        self.keychainManager = keychainManager
    }
    
    func signin(user: User) -> Single<APIResponse<Authorization>> {
        self.userAuthRepository.signin(user: user)
    }
    
    func verifySigninProcess(response: APIResponse<Authorization>) -> (isCompleted: Bool, message: String) {
        switch response {
        case .suceessData(let authData):
            return isAllTokenSaved(authData: authData) ?
            (true, "환영합니다 😆") : (false, TokenError.invalidToken.message)
        case .errorStatusCode(let stausCode):
            return (false, verifyErrorMessage(statusCode: stausCode))
        }
    }
    
    private func isAllTokenSaved(authData: Authorization) -> Bool {
        let isTokenSaved = keychainManager
            .save(
                key: .token,
                value: authData.accesstoken
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
    
    private func verifyErrorMessage(statusCode: Int) -> String {
        return UserSigninError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
    }
}
