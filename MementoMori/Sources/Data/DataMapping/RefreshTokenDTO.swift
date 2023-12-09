//
//  RefreshTokenDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/1/23.
//

import Foundation

struct RefreshTokenRequestDTO: Encodable {
    let id: String
    let accessToken: String
    let refreshToken: String
}

struct RefreshTokenResponseDTO: Decodable {
    let token: String
}
