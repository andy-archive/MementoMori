//
//  UserAuthDataSourceProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxSwift

protocol UserAuthDataSourceProtocol {
    func join(request: UserJoinRequestDTO) -> Single<NetworkResult<UserJoinResponseDTO>>
}
