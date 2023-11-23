//
//  NetworkError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/23/23.
//

import Foundation

enum NetworkError: Int, Error {
    case notValidKey = 420
    case tooManyRequests = 429
    case noResponse = 444
    case internalServerError = 500
}

extension NetworkError: LocalizedError {
    private var message: String {
        switch self {
        case .notValidKey:
            return "키가 적절하지 않습니다."
        case .tooManyRequests:
            return "과호출입니다."
        case .noResponse:
            return "응답 없음"
        case .internalServerError:
            return "서버 에러"
        }
    }
}
