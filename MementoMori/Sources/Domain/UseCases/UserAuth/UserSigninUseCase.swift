//
//  UserSigninUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxSwift

final class UserSigninUseCase: UserSigninUseCaseProtocol {
            
    //MARK: - Properties
    private let userAuthRepository: UserAuthRepositoryProtocol
    private let keychainRepository: KeychainRepositoryProtocol
    
    //MARK: - Initializer
    init(
        userAuthRepository: UserAuthRepositoryProtocol,
        keychainRepository: KeychainRepositoryProtocol
    ) {
        self.userAuthRepository = userAuthRepository
        self.keychainRepository = keychainRepository
    }
    
    //MARK: - Private Methods
    private func isAllTokenSaved(user: User) -> Bool {
        guard
            let userID = user.id,
            let accessToken = user.accessToken,
            let refreshToken = user.refreshToken
        else { return false }
        
        let isUserSaved = keychainRepository.save( key: "", value: userID, type: .userID )
        let isTokenSaved = keychainRepository.save( key: userID, value: accessToken, type: .accessToken )
        let isRefreshTokenSaved = keychainRepository.save( key: userID, value: refreshToken, type: .refreshToken )
        
        if isUserSaved && isTokenSaved && isRefreshTokenSaved { return true }
        
        return false
    }
    
    private func verifyErrorMessage(statusCode: Int) -> String {
        return UserSigninError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
    }
    
    //MARK: - Protocol Methods
    func signin(user: User) -> Single<APIResult<User>> {
        self.userAuthRepository.signin(user: user)
    }
    
    func checkAutoSignin() -> Observable<Bool> {
        
        let keychain = KeychainRepository.shared
        
        guard
            let userID = keychain.find(key: "", type: .userID),
            let _ = keychain.find(key: userID, type: .accessToken),
            let _ = keychain.find(key: userID, type: .refreshToken)
        else { return Observable.just(false) }
        
        return self.userAuthRepository.refresh()
            .map { result in
                switch result {
                case .suceessData(let authorization):
                    guard let updatedToken = authorization.accessToken else { return false }
                    if keychain.save(key: userID, value: updatedToken, type: .accessToken) {
                        return true
                    }
                    return false
                case .statusCode(let statusCode):
                    if statusCode == 409 { return true }
                    return false
                }
            }
            .asObservable()
    }
    
    func authenticate(result: APIResult<User>) -> (isAuthorized: Bool, message: String) {
        switch result {
        case .suceessData(let user):
            return isAllTokenSaved(user: user) ? (true, "환영합니다 😆") : (false, TokenError.invalidToken.message)
        case .statusCode(let statusCode):
            return (false, verifyErrorMessage(statusCode: statusCode))
        }
    }
}
