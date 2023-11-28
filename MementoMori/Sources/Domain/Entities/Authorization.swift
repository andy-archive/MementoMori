//
//  Authorization.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/27/23.
//

import Foundation

struct Authorization: Codable {
    let token: String
    let refreshToken: String
}
