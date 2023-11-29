//
//  UserJoinError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

enum UserJoinError: Int, ReusableError {
    case badRequest = 400
    case conflict = 409

    var message: String {
        switch self {
        case .badRequest:
            return "필수값을 채워주세요."
        case .conflict:
            return "이미 가입된 유저입니다."
        }
    }
}
