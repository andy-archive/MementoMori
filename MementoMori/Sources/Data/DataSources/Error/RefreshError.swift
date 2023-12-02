//
//  RefreshError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/30/23.
//

import Foundation

enum RefreshError: Int, ReusableError {
    case invalidToken = 200
    case unauthorized = 401
    case forbidden = 403
    case conflict = 409
    case refreshTokenExpired = 418

    var message: String {
        switch self {
        case .invalidToken:
            return "접속할 수 없습니다."
        case .unauthorized:
            return "인증할 수 없습니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .conflict:
            return "아직 로그인 상태입니다."
        case .refreshTokenExpired:
            return "다시 로그인해 주세요."
        }
    }
}
