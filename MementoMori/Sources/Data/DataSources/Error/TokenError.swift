//
//  TokenError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

enum TokenError: Int, ReusableError {
    case invalidToken = 200
    case badRequest = 400
    case unauthorized = 401

    var message: String {
        switch self {
        case .invalidToken:
            return "접속할 수 없습니다. 잠시 후 다시 시도해 주세요."
        case .badRequest:
            return "필수값을 채워주세요."
        case .unauthorized:
            return "계정을 확인해주세요."
        }
    }
    
}
