//
//  StoryReadDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

//MARK: - Request
struct StoryReadRequestDTO: Encodable {
    let next: String?
    let limit: String?
    let productId: String?
    
    enum CodingKeys: String, CodingKey {
        case next, limit
        case productId = "product_id"
    }
}

//MARK: - Response
struct StoryReadResponseDTO: Decodable {
    let data: [Story]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}
