//
//  UserAuthRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import RxSwift

protocol UserAuthRepositoryProtocol {
    func join(userInfo: User) -> Single<NetworkResult<User>>
}
