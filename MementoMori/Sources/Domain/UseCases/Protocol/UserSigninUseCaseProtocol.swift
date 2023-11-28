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
    var signinResponse: PublishRelay<NetworkResult<Void>> { get }
    func signin(userInfo: User) -> Single<NetworkResult<Authorization>>
}
