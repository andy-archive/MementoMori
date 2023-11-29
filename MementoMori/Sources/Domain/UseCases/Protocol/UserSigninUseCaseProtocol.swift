//
//  UserSigninUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxRelay
import RxSwift

protocol UserSigninUseCaseProtocol {
    var isEmailTextValid: PublishRelay<Bool> { get }
    var isPasswordTextValid: PublishRelay<Bool> { get }
    var isSigninButtonEnabled: BehaviorRelay<Bool> { get }
    var isSigninCompleted: PublishRelay<Bool> { get }
    var errorMessage: PublishRelay<String> { get }
    func signin(userInfo: User) -> Single<NetworkResult<Void>>
    func isTokenSaved(authData: Authorization) -> Bool
}
