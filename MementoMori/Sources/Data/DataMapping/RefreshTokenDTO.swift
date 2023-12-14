//
//  RefreshTokenDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/1/23.
//

import Foundation

struct RefreshTokenRequestDTO: Encodable {
    let accessToken: String
    let refreshToken: String
}

struct RefreshTokenResponseDTO: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "token"
    }
    
    func toDomain() -> Authorization {
        let domain = Authorization(accessToken: accessToken)
        
        return domain
    }
}
