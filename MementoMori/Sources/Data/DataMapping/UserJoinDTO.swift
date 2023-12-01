//
//  UserJoinDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import Foundation

struct UserJoinRequestDTO: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthday: String?
}

struct UserJoinResponseDTO: Decodable {
    let id: String
    let email: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case nickname = "nick"
    }
    
    func toDomain() -> User {
        return User(
            id: id,
            email: email,
            password: nil,
            nickname: nickname,
            phoneNum: nil, 
            birthday: nil,
            accessToken: nil,
            refreshToken: nil
        )
    }
}
