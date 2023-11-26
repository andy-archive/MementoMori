//
//  UserAuthRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import RxSwift

protocol UserAuthRepositoryProtocol {
    func join(userInfo: UserJoinRequestDTO) -> Single<Result<Void>>
}
