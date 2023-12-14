//
//  Authorization.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/14/23.
//

import Foundation

//MARK: - Entity
struct Authorization: Hashable {
    let id = UUID()
    let accessToken: String?
    let refreshToken: String?
}

//MARK: - Initializers
extension Authorization {
    
    init(
        accessToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = nil
    }
    
    init(
        accessToken: String,
        refreshToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
