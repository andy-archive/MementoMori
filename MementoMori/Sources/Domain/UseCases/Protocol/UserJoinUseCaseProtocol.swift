//
//  UserJoinUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import Foundation

import RxSwift

protocol UserJoinUseCaseProtocol {
    func validate(email: String) -> Observable<Bool>
    func join(user: User) -> Single<APIResult<User>>
}
