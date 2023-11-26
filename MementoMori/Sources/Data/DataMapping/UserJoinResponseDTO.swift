//
//  UserJoinResponseDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import Foundation

struct UserJoinResponseDTO: Decodable {
    let id: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case nick
    }
    
    func toDomain() -> User {
        return User(
            id: id,
            email: email,
            password: nil,
            nick: nick,
            phoneNum: nil,
            birthday: nil
        )
    }
}
