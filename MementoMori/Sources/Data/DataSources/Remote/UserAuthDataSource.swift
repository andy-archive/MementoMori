//
//  UserAuthDataSource.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import Moya
import RxSwift

struct UserAuthDataSource: UserAuthDataSourceProtocol {
    
    func join(request: UserJoinRequestDTO) -> Single<NetworkResult<UserJoinResponseDTO>> {
        APIManager.shared.request(api: .userJoin(model: request), responseType: UserJoinResponseDTO.self)
    }
}
