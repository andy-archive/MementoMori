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
    let id: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accessToken = "token"
        case refreshToken
    }

    func toDomain() -> User {
        return User(
            id: id,
            email: nil,
            password: nil,
            nickname: nil,
            phoneNum: nil,
            birthday: nil,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
