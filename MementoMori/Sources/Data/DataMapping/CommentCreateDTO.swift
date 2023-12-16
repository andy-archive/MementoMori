//
//  CommentCreateDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/16/23.
//

import Foundation

//MARK: - Request
struct CommentCreateRequestDTO: Encodable {
    let content: String
    let postID: String
}

//MARK: - Response
struct CommentCreateResponseDTO: Decodable {
    let id: String
    let content: String
    let creator: Creator
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content
        case creator
        case createdAt = "time"
    }
}
