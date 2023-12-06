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
    let productID: String?
    
    enum CodingKeys: String, CodingKey {
        case next, limit
        case productID = "product_id"
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
    
    func toDomain() -> (storyList: [StoryPost], nextCursor: String) {
        
        let domain = data.map { story in
            StoryPost(
                id: story.id,
                userID: story.creator.id,
                nickname: story.creator.nickname,
                title: story.title ?? "",
                content: story.content ?? "",
                imageList: story.image ?? [],
                commentList: [],
                location: story.location,
                isLiked: false,
                isSavedToMyCollection: false,
                createdAt: story.createdAt,
                storyType: .location
            )
        }
        
        return (domain, nextCursor)
    }
}
