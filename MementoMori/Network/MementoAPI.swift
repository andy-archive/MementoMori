//
//  MementoAPI.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/16.
//

import Foundation

import Moya

enum MementoAPI {
    case emailValidation(model: EmailValidationRequest)
}

extension MementoAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "\(MementoAPI.baseURL)")!
    }
    
    var path: String {
        switch self {
        case .emailValidation: return "validation/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .emailValidation(let data):
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
