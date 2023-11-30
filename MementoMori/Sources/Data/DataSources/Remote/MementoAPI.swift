//
//  MementoAPI.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/16.
//

import Foundation

import Moya

enum MementoAPI {
    case emailValidation(model: EmailValidationRequestDTO)
    case userJoin(model: UserJoinRequestDTO)
    case userSignin(model: UserSigninRequestDTO)
}

extension MementoAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "\(MementoAPI.baseURL)")!
    }
    
    var path: String {
        switch self {
        case .emailValidation: return "validation/email"
        case .userJoin: return "join"
        case .userSignin: return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation: return .post
        case .userJoin: return .post
        case .userSignin: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .emailValidation(let data):
            return .requestJSONEncodable(data)
        case .userJoin(let data):
            return .requestJSONEncodable(data)  
        case .userSignin(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SesacKey": "\(MementoAPI.secretKey)"
        ]
    }
}
