//
//  NetworkError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/23/23.
//

import Foundation

protocol ReusableError: Error {
    var rawValue: Int { get }
    var message: String { get }
}

enum NetworkError: Int, Error {
    case badRequest = 400
    case conflict = 409
    case notValidKey = 420
    case tooManyRequests = 429
    case noResponse = 444
    case internalServerError = 500
}

extension NetworkError: LocalizedError, ReusableError {
    internal var message: String {
        switch self {
        case .notValidKey:
            return "키가 적절하지 않습니다."
        case .tooManyRequests:
            return "과호출입니다."
        case .noResponse:
            return "응답 없음"
        case .internalServerError:
            return "서버 에러"
        default:
            return ""
        }
    }
}

enum SignupValidationError: Int, ReusableError {
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
