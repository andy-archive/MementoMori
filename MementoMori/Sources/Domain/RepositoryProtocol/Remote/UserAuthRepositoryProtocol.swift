//
//  UserAuthRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import RxSwift

protocol UserAuthRepositoryProtocol {
    func join(user: User) -> Single<APIResult<User>>
    func signin(user: User) -> Single<APIResult<User>>
}
