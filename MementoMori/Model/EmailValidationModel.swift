//
//  EmailValidationModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/16.
//

import Foundation

struct EmailValidationRequest: Encodable {
    let email: String
}

struct EmailValidationResponse: Decodable {
    let message: String
}
