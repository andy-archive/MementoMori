//
//  CommentCreateError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/16/23.
//

import Foundation

enum CommentCreateError: Int, ReusableError {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case conflict = 410
    case refreshTokenExpired = 419
    
    var message: String {
        switch self {
        case .badRequest:
            return "댓글을 입력해 주세요."
        case .unauthorized:
            return "인증되지 않았습니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .conflict:
            return "게시글을 찾을 수 없습니다."
        case .refreshTokenExpired:
            return "다시 로그인해 주세요."
        }
    }
}
