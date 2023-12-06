//
//  KeychainRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

enum KeyType: String {
    case userID
    case accessToken
    case refreshToken
}

protocol KeychainRepositoryProtocol {
    func save(key: String, value: String, type: KeyType) -> Bool
    func verify(key: String, type: KeyType) -> String?
    func delete(key: String, type: KeyType) -> Bool
}
