//
//  UserSigninUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxSwift

protocol UserSigninUseCaseProtocol {
    func signin(user: User) -> Single<APIResponse<Authorization>>
    func verifySigninProcess(response: APIResponse<Authorization>) -> (isCompleted: Bool, message: String)
}
