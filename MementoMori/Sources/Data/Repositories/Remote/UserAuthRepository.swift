//
//  UserAuthRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxSwift

final class UserAuthRepository: UserAuthRepositoryProtocol {
    
    func join(user: User) -> Single<APIResponse<User>> {
        
        let requestDTO = UserJoinRequestDTO(
            email: user.email,
            password: user.password ?? "",
            nick: user.nick ?? "",
            phoneNum: user.phoneNum,
            birthday: user.birthday
        )
        
        let responseDTO = APIManager.shared.request(
            api: .userJoin(model: requestDTO),
            responseType: UserJoinResponseDTO.self
        )
        
        let result = responseDTO.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResponse>.just(.suceessData(responseDTO.toDomain()))
            case .errorStatusCode(let statusCode):
                return Single<APIResponse>.just(.errorStatusCode(statusCode))
            }
        }
        
        return result
    }
    
    func signin(user: User) -> Single<APIResponse<Authorization>> {
        
        let requestDTO = UserSigninRequestDTO(
            email: user.email,
            password: user.password ?? ""
        )
        
        let responseDTO = APIManager.shared.request(
            api: .userSignin(model: requestDTO),
            responseType: UserSigninResponseDTO.self
        )
        
        let result = responseDTO.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResponse>.just(.suceessData(responseDTO.toDomain()))
            case .errorStatusCode(let statusCode):
                return Single<APIResponse>.just(.errorStatusCode(statusCode))
            }
        }
        
        return result
    }
}
