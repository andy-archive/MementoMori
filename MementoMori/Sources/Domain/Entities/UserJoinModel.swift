//
//  UserJoinModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/23/23.
//

import Foundation

struct UserJoinRequest: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthday: String?
}

struct UserJoinSuccessResponse: Decodable {
    let id: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case nick
    }
}

struct UserJoinFailureResponse: Decodable {
    let message: String
}
