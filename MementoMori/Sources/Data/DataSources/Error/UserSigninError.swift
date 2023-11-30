//
//  UserSigninError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

enum UserSigninError: Int, ReusableError {
    case badRequest = 400
    case unauthorized = 401
    
    var message: String {
        switch self {
        case .badRequest:
            return "필수값을 채워주세요."
        case .unauthorized:
            return "계정을 확인해주세요."
        }
    }
}
