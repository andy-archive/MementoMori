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
    
    func signin(user: User) -> Single<APIResult<User>> {
        
        let requestDTO = UserSigninRequestDTO(
            email: user.email ?? "",
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
    
    func refresh(user: User) -> Single<APIResult<Void>> {
        
        guard let id = user.id,
              let accessToken = user.accessToken,
              let refreshToken = user.refreshToken else {
            return Single<APIResult<Void>>
                .just(.errorStatusCode(RefreshError.invalidToken.rawValue))
        }
        
        let requestDTO = RefreshTokenRequestDTO(
            id: id,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
        let responseDTO = APIManager.shared.request(
            api: .refreshToken(model: requestDTO),
            responseType: UserSigninResponseDTO.self
        )
        
        let result = responseDTO.flatMap { result in
            switch result {
            case .suceessData(_):
                return Single<APIResult>.just(.suceessData(()))
            case .errorStatusCode(let statusCode):
                return Single<APIResult>.just(.errorStatusCode(statusCode))
            }
        }
        
        return result
    }
}
