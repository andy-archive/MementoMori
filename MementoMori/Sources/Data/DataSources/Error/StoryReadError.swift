//
//  StoryReadError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

enum StoryReadError: Int, ReusableError {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case refreshTokenExpired = 419
    
    var message: String {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "인증되지 않았습니다"
        case .forbidden:
            return "접근 권한이 없습니다."
        case .refreshTokenExpired:
            return "다시 로그인해 주세요."
        }
    }
}
