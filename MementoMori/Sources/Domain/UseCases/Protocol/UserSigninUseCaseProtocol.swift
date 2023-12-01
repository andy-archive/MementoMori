//
//  UserSigninUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxSwift

protocol UserSigninUseCaseProtocol {
    func signin(user: User) -> Single<APIResult<Authorization>>
    func verifySigninProcess(response: APIResult<Authorization>) -> (isCompleted: Bool, message: String)
}
