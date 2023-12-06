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
    let limit: String
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
    
    func toDomain() -> [StoryPost] {
        
        let domain = data.map { story in
            StoryPost(
                id: story.id,
                userID: story.creator.id,
                title: story.title,
                content: story.content,
                imageList: story.image,
                commentList: story.comments,
                location: story.location,
                isLiked: false,
                isSavedToMyCollection: false,
                createdAt: story.createdAt,
                storyType: .location
            )
        }
        
        return domain
    }
}
