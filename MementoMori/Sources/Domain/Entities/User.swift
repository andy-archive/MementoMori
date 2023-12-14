//
//  User.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import Foundation

//MARK: - Entity
struct User: Hashable {
    let id: String?
    let email: String?
    let password: String?
    let nickname: String?
    let phoneNum: String?
    let birthday: String?
    let accessToken: String?
    let refreshToken: String?
}

//MARK: - Initializer
extension User {
    
    init(
        id: String,
        accessToken: String,
        refreshToken: String
    ) {
        self.id = id
        self.email = nil
        self.password = nil
        self.nickname = nil
        self.phoneNum = nil
        self.birthday = nil
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
