//
//  KeychainManager.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

enum KeyType: String {
    case token
    case refreshToken
}

protocol KeychainManager {
    func save(key: KeyType, value: String) -> Bool
    func verify(key: KeyType) -> String?
    func delete(key: KeyType) -> Bool
}
