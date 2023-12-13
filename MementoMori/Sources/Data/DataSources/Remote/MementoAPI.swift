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
    case refreshToken(model: RefreshTokenRequestDTO)
    case storyCreate(model: StoryCreateRequestDTO)
    case storyRead(model: StoryReadRequestDTO)
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
        case .refreshToken: return "refresh"
        case .storyCreate, .storyRead: return "post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation: return .post
        case .userJoin: return .post
        case .userSignin: return .post
        case .refreshToken: return .get
        case .storyCreate: return .post
        case .storyRead: return .get
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
        case .refreshToken:
            return .requestPlain
        case .storyCreate(let storyPost):
            var multiFormData: [MultipartFormData] = []
            storyPost.imageDataList.forEach { imageData in
                multiFormData.append(
                    MultipartFormData(
                        provider: .data(imageData),
                        name: "file",
                        fileName: "storyPost.jpeg",
                        mimeType: "image/jpeg"
                    )
                )
            }
            multiFormData.append(MultipartFormData(provider: .data(storyPost.content.data(using: .utf8)!), name: "content"))
            multiFormData.append(MultipartFormData(provider: .data(storyPost.productID.data(using: .utf8)!), name: "product_id"))
            return .uploadMultipart(multiFormData)
        case .storyRead(let data):
            guard let productID = data.productID else {
                return .requestParameters(
                    parameters: ["limit": data.limit],
                    encoding: URLEncoding.queryString
                )
            }
            guard let next = data.next else {
                return .requestParameters(
                    parameters: ["limit": data.limit, "product_id": productID],
                    encoding: URLEncoding.queryString
                )
            }
            return .requestParameters(
                parameters: ["next": next, "limit": data.limit, "product_id": productID],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation, .userJoin, .userSignin:
            [
                "Content-Type": "application/json",
                "SesacKey": "\(MementoAPI.secretKey)"
            ]
        case .refreshToken(let data):
            [
                "Authorization": "\(data.accessToken)",
                "SesacKey": "\(MementoAPI.secretKey)",
                "Refresh": "\(data.refreshToken)"
            ]
        case .storyCreate(_):
            [
                "Content-Type": "multipart/form-data",
                "SesacKey": "\(MementoAPI.secretKey)",
            ]
        case .storyRead(_):
            [
                "SesacKey": "\(MementoAPI.secretKey)",
            ]
        }
    }
}

extension MementoAPI {
    var validationType: ValidationType {
        return .successCodes
    }
}
