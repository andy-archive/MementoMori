//
//  UserAuthRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import Foundation

import RxSwift

final class UserAuthRepository: UserAuthRepositoryProtocol {
    
    func validate(email: String) -> Single<APIResult<Void>> {
        let requestDTO = EmailValidationRequestDTO(email: email)
        
        let resonseSingle = APIManager.shared.request(
            api: .emailValidation(model: requestDTO),
            responseType: EmailValidationResponseDTO.self,
            isWithToken: false
        )
        
        let resultSingle = resonseSingle.flatMap { result in
            switch result {
            case .suceessData:
                return Single<APIResult>.just(.suceessData(Void()))
            case .statusCode(let statusCode):
                if statusCode == 200 { return Single<APIResult>.just(.suceessData(Void())) }
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return resultSingle
    }
    
    func join(user: User) -> Single<APIResult<User>> {
        let requestDTO = UserJoinRequestDTO(
            email: user.email ?? "",
            password: user.password ?? "",
            nick: user.nickname ?? "",
            phoneNum: user.phoneNum,
            birthday: user.birthday
        )
        
        let resonseSingle = APIManager.shared.request(
            api: .userJoin(model: requestDTO),
            responseType: UserJoinResponseDTO.self,
            isWithToken: false
        )
        
        let resultSingle = resonseSingle.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .statusCode(let statusCode):
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return resultSingle
    }
    
    func signin(user: User) -> Single<APIResult<User>> {
        let requestDTO = UserSigninRequestDTO(
            email: user.email ?? "",
            password: user.password ?? ""
        )
        
        let resonseSingle = APIManager.shared.request(
            api: .userSignin(model: requestDTO),
            responseType: UserSigninResponseDTO.self
        )
        
        let resultSingle = resonseSingle.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .statusCode(let statusCode):
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return resultSingle
    }
    
    func refresh() -> Single<APIResult<Authorization>> {
        let resonseSingle = APIManager.shared.request(
            api: .refreshToken,
            responseType: RefreshTokenResponseDTO.self
        )
        
        let resultSingle = resonseSingle.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .statusCode(let statusCode):
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return resultSingle
    }
}
