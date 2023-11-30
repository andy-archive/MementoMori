//
//  UserSigninDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import Foundation

struct UserSigninRequestDTO: Encodable {
    let email: String
    let password: String
}

struct UserSigninResponseDTO: Decodable {
    let token: String
    let refreshToken: String

    func toDomain() -> Authorization {
        return Authorization(
            accesstoken: token,
            refreshToken: refreshToken
        )
    }
}
