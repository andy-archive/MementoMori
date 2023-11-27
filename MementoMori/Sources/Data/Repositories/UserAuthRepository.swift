//
//  UserAuthRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxSwift

struct UserAuthRepository: UserAuthRepositoryProtocol {
    
    func join(userInfo: User) -> Single<NetworkResult<User>> {
        
        let requestDTO = UserJoinRequestDTO(
            email: userInfo.email,
            password: userInfo.password ?? "",
            nick: userInfo.nick,
            phoneNum: userInfo.phoneNum,
            birthday: userInfo.birthday
        )
        
        let response = APIManager.shared.request(api: .userJoin(model: requestDTO), responseType: UserJoinResponseDTO.self)
        
        let result = response.flatMap { result in
            switch result {
            case .success(let dto):
                return Single<NetworkResult>.just(.success(dto.toDomain()))
            case .failure(let error):
                return Single<NetworkResult>.just(.failure(error))
            }
        }
        
        return result
    }

}
