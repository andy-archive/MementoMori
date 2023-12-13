//
//  UserAuthRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxSwift

final class UserAuthRepository: UserAuthRepositoryProtocol {
    
    func join(user: User) -> Single<APIResult<User>> {
        
        let requestDTO = UserJoinRequestDTO(
            email: user.email ?? "",
            password: user.password ?? "",
            nick: user.nickname ?? "",
            phoneNum: user.phoneNum,
            birthday: user.birthday
        )
        
        let singleResponse = APIManager.shared.request(
            api: .userJoin(model: requestDTO),
            responseType: UserJoinResponseDTO.self,
            isWithToken: false
        )
        
        let singleResult = singleResponse.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .statusCode(let statusCode):
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return singleResult
    }
    
    func signin(user: User) -> Single<APIResult<User>> {
        
        let requestDTO = UserSigninRequestDTO(
            email: user.email ?? "",
            password: user.password ?? ""
        )
        
        let singleResponse = APIManager.shared.request(
            api: .userSignin(model: requestDTO),
            responseType: UserSigninResponseDTO.self
        )
        
        let singleResult = singleResponse.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .statusCode(let statusCode):
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return singleResult
    }
}
