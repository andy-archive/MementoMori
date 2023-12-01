//
//  UserAuthRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import RxSwift

final class UserAuthRepository: UserAuthRepositoryProtocol {
    
    //MARK: UserAuthRepositoryProtocol
    
    func join(user: User) -> Single<APIResult<User>> {
        
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
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .errorStatusCode(let statusCode):
                return Single<APIResult>.just(.errorStatusCode(statusCode))
            }
        }
        
        return result
    }
    
    func signin(user: User) -> Single<APIResult<Authorization>> {
        
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
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .errorStatusCode(let statusCode):
                return Single<APIResult>.just(.errorStatusCode(statusCode))
            }
        }
        
        return result
    }
}
