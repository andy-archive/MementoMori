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
    
    //MARK: - Private Methods
    /// 이메일 검증 요청
    private func requestPOST(email: String) -> Single<APIResult<Void>> {
        let response = userAuthRepository.validate(email: email)
        return response
    }
    
    //MARK: - Protocol Methods
    /// 이메일 검증 요청
    func validate(email: String) -> Observable<Bool> {
        let observable = Observable.just(Void())
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.requestPOST(email: email)
            }
            .map { result in
                switch result {
                case .suceessData:
                    return true
                case .statusCode(let statusCode):
                    if statusCode == 200 { return true }
                    return false
                }
            }
            .asObservable()
        
        return observable
    }
    
    /// 가입 요청
    func join(user: User) -> Single<APIResult<User>> {
        return userAuthRepository.join(user: user)
    }
}
