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
    let data: [StoryItemResponseDTO]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
    func toDomain() -> (storyList: [StoryPost], nextCursor: String) {
        
        let domain = data.map { story in
            StoryPost(
                id: story.id,
                nickname: story.creator.nickname,
                content: story.content ?? "",
                imageFilePathList: story.imageFilePathList,
                createdAt: story.createdAt
            )
        }
        
        return (domain, nextCursor)
    }
}
