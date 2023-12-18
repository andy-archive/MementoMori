//
//  CommentDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/16/23.
//

import Foundation

//MARK: - Response
struct CommentDTO: Decodable {
    let id: String
    let content: String
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content, time
    }
    
    func toDomain() -> Comment {
        let comment = Comment(
            id: id,
            content: content,
            createdAt: time,
            storyPostID: nil
        )
        return comment
    }
}
