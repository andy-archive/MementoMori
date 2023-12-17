//
//  UserJoinUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import Foundation

import RxSwift

protocol UserJoinUseCaseProtocol {
    func join(user: User) -> Single<APIResult<User>>
}
