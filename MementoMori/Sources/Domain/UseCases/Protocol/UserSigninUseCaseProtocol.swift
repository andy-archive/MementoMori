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
    func signin(user: User) -> Single<APIResponse<Authorization>>
    func verifySigninProcess(response: APIResponse<Authorization>) -> (isCompleted: Bool, message: String)
}
