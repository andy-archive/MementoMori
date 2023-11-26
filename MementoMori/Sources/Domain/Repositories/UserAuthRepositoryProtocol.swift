//
//  UserAuthRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import RxSwift

protocol AuthRepositoryProtocol {
    func join(userInfo: UserJoinRequest) -> Single<Result<Void>>
}
