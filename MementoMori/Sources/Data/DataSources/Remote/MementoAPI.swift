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
    case refresh(model: User)
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
        case .refresh: return "refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation: return .post
        case .userJoin: return .post
        case .userSignin: return .post
        case .refresh: return .get
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
        case .refresh(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation, .userJoin, .userSignin:
            [
                "Content-Type": "application/json",
                "SesacKey": "\(MementoAPI.secretKey)"
            ]
        case .refresh(let data):
            [
                "Authorization": "\(data.accessToken ?? "")",
                "SesacKey": "\(MementoAPI.secretKey)",
                "Refresh": "\(data.refreshToken ?? "")"
            ]
        }
        
    }
}
