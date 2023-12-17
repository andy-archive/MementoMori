//
//  UserSigninUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import Foundation

import RxSwift

protocol UserSigninUseCaseProtocol {
    func signin(user: User) -> Single<APIResult<User>>
    func authenticate(result: APIResult<User>) -> (isAuthorized: Bool, message: String)
    func checkAutoSignin() -> Observable<Bool>
}
