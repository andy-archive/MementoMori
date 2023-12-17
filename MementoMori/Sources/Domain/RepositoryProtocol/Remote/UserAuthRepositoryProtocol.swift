//
//  UserAuthRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import Foundation

import RxSwift

protocol UserAuthRepositoryProtocol {
    func validate(email: String) -> Single<APIResult<Void>>
    func join(user: User) -> Single<APIResult<User>>
    func signin(user: User) -> Single<APIResult<User>>
    func refresh() -> Single<APIResult<Authorization>>
}
