//
//  EmailValidationDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import Foundation

struct EmailValidationRequestDTO: Encodable {
    let email: String
}

struct EmailValidationResponseDTO: Decodable {
    let message: String
}
