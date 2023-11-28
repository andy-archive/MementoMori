//
//  UserAuthRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxSwift

final class UserAuthRepository: UserAuthRepositoryProtocol {
    
    func join(userInfo: User) -> Single<NetworkResult<User>> {
        
        let requestDTO = UserJoinRequestDTO(
            email: userInfo.email,
            password: userInfo.password ?? "",
            nick: userInfo.nick ?? "",
            phoneNum: userInfo.phoneNum,
            birthday: userInfo.birthday
        )
        
        let responseDTO = APIManager.shared.request(
            api: .userJoin(model: requestDTO),
            responseType: UserJoinResponseDTO.self
        )
        
        let result = responseDTO.flatMap { result in
            switch result {
            case .success(let responseDTO):
                return Single<NetworkResult>.just(.success(responseDTO.toDomain()))
            case .failure(let error):
                return Single<NetworkResult>.just(.failure(error))
            }
        }
        
        return result
    }
    
    func signin(userInfo: User) -> Single<NetworkResult<Authorization>> {
        
        let requestDTO = UserSigninRequestDTO(
            email: userInfo.email,
            password: userInfo.password ?? ""
        )
        
        let responseDTO = APIManager.shared.request(
            api: .userSignin(model: requestDTO),
            responseType: UserSigninResponseDTO.self
        )
        
        let result = responseDTO.flatMap { result in
            switch result {
            case .success(let responseDTO):
                print(responseDTO.token, responseDTO.refreshToken)
                return Single<NetworkResult>.just(.success(responseDTO.toDomain()))
            case .failure(let error):
                return Single<NetworkResult>.just(.failure(error))
            }
        }
        
        return result
    }
}
